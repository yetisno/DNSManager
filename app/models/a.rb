class A < ActiveRecord::Base
	require 'resolv'
	include PtrCombined
	belongs_to :domain
	validates :to_ip, presence: true, :format => {:with => Resolv::IPv4::Regex}
end
