json.array!(@as) do |as|
	json.extract! as, :id, :domain_id, :name
	json.url domain_as_url(as, format: :json)
end
