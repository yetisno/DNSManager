class Api::DomainsNameserversController < ApiDomainController
	include Loginable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@nameservers = getDomain.nameservers
	end

	def show
		@nameserver = getDomain.nameservers.find @id
	end

	def create
		begin
			getDomain.nameservers.create! params.require(:domains_nameserver).permit(:name, :to_ns)
			@success = true
		rescue
			@success = false
		end
	end

	def destroy
		@nameserver = getDomain.nameservers.find @id
		begin
			@nameserver.destroy!
			@success = true
		rescue
			@success = false
		end
	end
end
