class AdminDomainsController < ApplicationController
	before_action :loginCheck

	def index
		@domains = Domain.all
	end
end
