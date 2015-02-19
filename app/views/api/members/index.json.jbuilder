json.counts @members.count
json.data @members do |member|
	json.extract! member, :id, :username, :email
end
