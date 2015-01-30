class Domain < ActiveRecord::Base
	has_many :user_domain_maps
	has_many :users, :through => :user_domain_maps
	has_one :soa
	has_many :as
	has_many :cnames
	has_many :mxes
	has_many :nameservers
	has_many :ptrs
end
