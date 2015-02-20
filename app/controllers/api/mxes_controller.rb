class Api::MxesController < ApiDomainController
	include Loginable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@domain = getDomain
		@mxes = @domain.mxes
	end

	def show
		@mx = getDomain.mxes.find @id
	end

	def create
		begin
			getDomain.mxes.create! params.require(:mx).permit(:name, :priority, :to_name)
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
			@mx = getDomain.mxes.find @id
			@mx.destroy!
			@success = true
		rescue
			@success = false
		end
		respond_to do |format|
			format.json { render status: @success ? :ok : :bad_request }
		end
	end
end
