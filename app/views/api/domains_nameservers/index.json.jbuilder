json.count @nameservers.count
json.data @nameservers do |nameserver|
	json.extract! nameserver, :id, :domain_id, :name, :to_ns
end
