json.counts @as.count
json.data @as do |a|
	json.extract! a, :id, :domain_id, :name, :to_ip
end
