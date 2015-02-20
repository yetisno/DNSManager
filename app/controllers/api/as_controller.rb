class Api::AsController < ApiDomainController
	include Loginable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@domain = getDomain
		@as = @domain.as
	end

	def show
		@a = getDomain.as.find @id
	end

	def create
		begin
			getDomain.as.create! params.require(:a).permit(:name, :to_ip)
			@success = true
		rescue
			@success = false
		end
		respond_to do |format|
			format.json { render status: @success ? :created : :bad_request }
		end
	end

	def destroy
		begin
			@a = getDomain.as.find @id
			@a.destroy!
			@success = true
		rescue
			@success = false
		end
		respond_to do |format|
			format.json { render status: @success ? :ok : :bad_request }
		end
	end
end
