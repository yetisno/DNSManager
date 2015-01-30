class User < ActiveRecord::Base
	# Include default devise modules. Others available are:
	# :token_authenticatable, :confirmable,
	# :lockable, :timeoutable and :omniauthable,
	devise :database_authenticatable,:registerable,
	       :recoverable, :rememberable, :trackable, :validatable,
	       :authentication_keys => [:login]
	has_many :user_domain_maps
	has_many :domains, :through => :user_domain_maps
	attr_accessor :login

	validates :username, presence: true, uniqueness: {case_sensitive: false}

	def self.find_for_database_authentication(warden_conditions)
		conditions = warden_conditions.dup
		if login = conditions.delete(:login)
			where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value", {:value => login.downcase}]).first
		else
			where(conditions.to_h).first
		end
	end
end
