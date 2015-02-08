class AdminDomainsController < ApplicationController
	include Loginable

	def index
		@domains = Domain.all
	end
end
