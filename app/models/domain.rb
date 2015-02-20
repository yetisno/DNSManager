class Domain < ActiveRecord::Base
	extend FriendlyId
	friendly_id :name, use: :slugged
	has_many :user_domain_maps
	has_many :users, :through => :user_domain_maps
	has_one :soa
	has_many :as
	has_many :cnames
	has_many :mxes
	has_many :nameservers
	validates :name, presence: true

	def url_name
		name.gsub '.', '-'
	end

	def self.r_url_name(name)
		name.gsub '-', '.'
	end
end
