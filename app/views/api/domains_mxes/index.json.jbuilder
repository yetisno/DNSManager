json.counts @mxes.count
json.data @mxes do |mx|
	json.extract! mx, :id, :domain_id, :name, :priority, :to_name
end
