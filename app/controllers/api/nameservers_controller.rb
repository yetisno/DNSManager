class Api::NameserversController < ApiDomainController
	include Loginable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@domain = getDomain
		@nameservers = @domain.nameservers
	end

	def show
		@nameserver = getDomain.nameservers.find @id
	end

	def create
		begin
			getDomain.nameservers.create! params.require(:nameserver).permit(:name, :to_ns)
			@success = true
		rescue
			@success = false
		end
		respond_to do |format|
			format.json { render status: @success ? :ok : :bad_request }
		end
	end

	def destroy
		begin
			@nameserver = getDomain.nameservers.find @id
			@nameserver.destroy!
			@success = true
		rescue
			@success = false
		end
		respond_to do |format|
			format.html { redirect_to :back }
		end
	end
end
