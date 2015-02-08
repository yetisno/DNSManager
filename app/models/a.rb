class A < ActiveRecord::Base
	include PtrCombined
	belongs_to :domain
end
