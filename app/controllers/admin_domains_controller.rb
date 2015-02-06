class AdminDomainsController < ApplicationController
	before_action :login_required

	def index
		@domains = Domain.all
	end
end
