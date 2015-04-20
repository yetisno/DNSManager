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
			@as[a.name] += [a] unless @as[a.name].blank?
			@as[a.name] = [a] if @as[a.name].blank?
		}
		Cname.all.each { |cname|
			@cnames[cname.name] += [cname] unless @cnames[cname.name].blank?
			@cnames[cname.name] = [cname] if @cnames[cname.name].blank?
		}
		Mx.all.each { |mx|
			@mxes[mx.name] += [mx] unless @mxes[mx.name].blank?
			@mxes[mx.name] = [mx] if @mxes[mx.name].blank?
		}
		Nameserver.all.each { |nameserver|
			@nameservers[nameserver.name] += [nameserver] unless @nameservers[nameserver.name].blank?
			@nameservers[nameserver.name] = [nameserver] if @nameservers[nameserver.name].blank?
		}
		Soa.all.each { |soa|
			@soas[soa.name] += [soa] unless @soas[soa.name].blank?
			@soas[soa.name] = [soa] if @soas[soa.name].blank?
		}
		Ptr.all.each { |ptr|
			@ptrs[ptr.ip_arpa] += [ptr] unless @ptrs[ptr.ip_arpa].blank?
			@ptrs[ptr.ip_arpa] = [ptr] if @ptrs[ptr.ip_arpa].blank?
		}
	end

	def a_handler(transaction)
		name = transaction.question.to_s
		if @as[name].blank? && @cnames[name].blank?
			transaction.fail!(:NXDomain)
		else
			unless @cnames[name].blank?
				@cnames[name].each { |cname|
					transaction.respond!(NAME.create(cname.to_name), {:ttl => TTL, resource_class: TYPE::CNAME})
					if @as.include?(cname.to_name)
						@as[cname.to_name].each { |a|
							transaction.respond!(a.to_ip, {:ttl => TTL, resource_class: TYPE::A, name: cname.to_name})
						}
					else
						transaction.passthrough!(FORWARDER)
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
		name = transaction.question.to_s
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
		name = transaction.question.to_s
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
		name = transaction.question.to_s
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
		name = transaction.question.to_s
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
		name = transaction.question.to_s
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
