require 'singleton'
class EmbedDNS
	include Singleton

	CONFIG = YAML.load_file('config/dnsmanager.yml')['dnsmanager']
	BIND_IP = CONFIG['dns-bind-ip']
	BIND_PORT = CONFIG['dns-bind-port']
	TTL = CONFIG['dns-ttl']
	RECURSIVE_QUERY = CONFIG['dns-recursive-query']
	NAME = Resolv::DNS::Name
	TYPE = Resolv::DNS::Resource::IN
	FORWARDER = RubyDNS::Resolver.new([[:udp, CONFIG['dns-forwarder-ip'], CONFIG['dns-forwarder-port']],
	                                   [:tcp, CONFIG['dns-forwarder-ip'], CONFIG['dns-forwarder-port']]])
	@@updated = true

	def initialize
		init_resources
	end

	def interfaces
		[
			[:udp, BIND_IP, BIND_PORT],
			[:tcp, BIND_IP, BIND_PORT]
		]
	end

	def init_resources
		@as = {}
		@cnames = {}
		@mxes = {}
		@nameservers = {}
		@soas = {}
		@ptrs = {}

		A.all.each { |a|
			name = a.name.upcase
			@as[name] += [a] unless @as[name].blank?
			@as[name] = [a] if @as[name].blank?
		}
		Cname.all.each { |cname|
			name = cname.name.upcase
			@cnames[name] += [cname] unless @cnames[name].blank?
			@cnames[name] = [cname] if @cnames[name].blank?
		}
		Mx.all.each { |mx|
			name = mx.name.upcase
			@mxes[name] += [mx] unless @mxes[name].blank?
			@mxes[name] = [mx] if @mxes[name].blank?
		}
		Nameserver.all.each { |nameserver|
			name = nameserver.name.upcase
			@nameservers[name] += [nameserver] unless @nameservers[name].blank?
			@nameservers[name] = [nameserver] if @nameservers[name].blank?
		}
		Soa.all.each { |soa|
			name = soa.name.upcase
			@soas[name] += [soa] unless @soas[name].blank?
			@soas[name] = [soa] if @soas[name].blank?
		}
		Ptr.all.each { |ptr|
			name = ptr.ip_arpa.upcase
			@ptrs[name] += [ptr] unless @ptrs[name].blank?
			@ptrs[name] = [ptr] if @ptrs[name].blank?
		}
	end

	def a_handler(transaction)
		name = transaction.question.to_s.upcase
		if @as[name].blank? && @cnames[name].blank?
			transaction.fail!(:NXDomain)
		else
			unless @cnames[name].blank?
				@cnames[name].each { |cname|
					transaction.respond!(NAME.create(cname.to_name), {:ttl => TTL, resource_class: TYPE::CNAME})
					if @as.include?(cname.to_name.upcase)
						@as[cname.to_name.upcase].each { |a|
							transaction.respond!(a.to_ip, {:ttl => TTL, resource_class: TYPE::A, name: cname.to_name})
						}
					else
						response = FORWARDER.query(cname.to_name)
						response.answer.each do |obj|
							req_name = obj[0].to_s
							obj.each { |record|
								if record.class == Resolv::DNS::Resource::IN::CNAME
									transaction.respond!(NAME.create(record.name.to_s), {:ttl => TTL, resource_class: TYPE::CNAME, name: req_name})
								end
								if record.class == Resolv::DNS::Resource::IN::A
									transaction.respond!(record.address.to_s, {:ttl => TTL, resource_class: TYPE::A, name: req_name})
								end
							}
						end
					end
				}
			else
				@as[name].each { |a|
					transaction.respond!(a.to_ip, {:ttl => TTL})
				}
			end
			@matched = true
		end
	end

	def cname_handler(transaction)
		name = transaction.question.to_s.upcase
		if @cnames[name].blank?
			transaction.fail!(:NXDomain)
		else
			@cnames[name].each { |cname|
				transaction.respond!(NAME.create(cname.to_name), {:ttl => TTL})
			}
			@matched = true
		end
	end

	def mx_handler(transaction)
		name = transaction.question.to_s.upcase
		if @mxes[name].blank?
			transaction.fail!(:NXDomain)
		else
			@mxes[name].each { |mx|
				transaction.respond!(mx.priority, NAME.create(mx.to_name), {:ttl => TTL})
			}
			@matched = true
		end
	end

	def soa_handler(transaction)
		name = transaction.question.to_s.upcase
		if @soas[name].blank?
			transaction.fail!(:NXDomain)
		else
			@soas[name].each { |soa|
				transaction.respond!(NAME.create(soa.name),
				                     NAME.create(soa.contact),
				                     soa.serial,
				                     soa.refresh,
				                     soa.retry,
				                     soa.expire,
				                     soa.minimum, {:ttl => TTL})
			}
			@matched = true
		end
	end

	def ns_handler(transaction)
		name = transaction.question.to_s.upcase
		if @nameservers[name].blank?
			transaction.fail!(:NXDomain)
		else
			@nameservers[name].each { |nameserver|
				transaction.respond!(NAME.create(nameserver.to_ns), {:ttl => TTL})
			}
			@matched = true
		end
	end

	def ptr_handler(transaction)
		name = transaction.question.to_s.upcase
		if @ptrs[name].blank?
			transaction.fail!(:NXDomain)
		else
			@ptrs[name].each { |ptr|
				transaction.respond!(NAME.create(ptr.to_name), {:ttl => TTL})
			}
			@matched = true
		end
	end

	def otherwise_handler(transaction)
		transaction.passthrough!(FORWARDER)
	end

	def pre_match(transaction)
		@matched = false
		init_resources if @@updated
		@@updated = false
	end

	def post_match(transaction)
		otherwise_handler transaction if RECURSIVE_QUERY && !@matched
	end

	def lazy_reload
		@writer.puts
	end

	def destroy
		# $DNS_PID.exit
		# Process.kill('KILL', $DNS_PID)
		# Process.wait $DNS_PID
	end

	def start
		dns = self
		reader, writer = IO.pipe
		@writer = writer

		$DNS_PID = Thread.new do

			RubyDNS::run_server(:listen => dns.interfaces) do
				match /.*/ do |transaction|
					dns.pre_match transaction
					# puts transaction.options[:peer]
					next!
				end

				match /.*/, TYPE::A do |transaction|
					dns.a_handler transaction
					next!
				end

				match /.*/, TYPE::CNAME do |transaction|
					dns.cname_handler transaction
					next!
				end

				match /.*/, TYPE::MX do |transaction|
					dns.mx_handler transaction
					next!
				end

				match /.*/, TYPE::NS do |transaction|
					dns.ns_handler transaction
					next!
				end

				match /.*/, TYPE::SOA do |transaction|
					dns.soa_handler transaction
					next!
				end

				match /.*/, TYPE::PTR do |transaction|
					dns.ptr_handler transaction
					next!
				end

				match /.*/ do |transaction|
					dns.post_match transaction
				end

				Thread.new {

					while true
						reader.gets
						@@updated = true
					end
				}

			end
		end
	end

end
