class ApiDomainController < ApiController

	def getDomain
		@domain_name = params[:domain_id]
		if admin?
			Domain.friendly.find(@domain_name)
		else
			@user.domains.includes(:as).friendly.find(@domain_name)
		end
	end
end
