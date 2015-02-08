class Api::DomainsAsController < ApplicationController
	include Loginable
	include Apiable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@as = getDomain.as
	end

	def show
		@a = getDomain.as.find @id
	end

	def destroy
		@a = getDomain.as.find @id
		begin
			@a.destroy!
			@success = true
		rescue
			@success = false
		end
	end

end
