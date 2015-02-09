json.count @cnames.count
json.data @cnames do |cname|
	json.extract! cname, :id, :domain_id, :name, :to_name
end
