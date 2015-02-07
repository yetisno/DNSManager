class DomainsAsController < ApplicationController
	before_action 'loginCheck'
	before_action do
		@user = current_user
		@domain_id = params[:domain_id]
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@as = getDomain.as.all
	end

	def show
		@a = getDomain.as.find(@id)
	end

	def destroy
		@a = getDomain.as.find(@id)
		@a.destroy!
	end

	def getDomain
		if admin?
			Domain.find(@domain_id)
		else
			@user.domains.find(@domain_id);
		end
	end

end
