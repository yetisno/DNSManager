class Soa < ActiveRecord::Base
	belongs_to :domain
	validates :serial, numericality: :only_integer
	validates :refresh, numericality: :only_integer
	validates :retry, numericality: :only_integer
	validates :expire, numericality: :only_integer
	validates :minimum, numericality: :only_integer
end
