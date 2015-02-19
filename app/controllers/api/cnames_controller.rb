class Api::CnamesController < ApiDomainController
	include Loginable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@domain = getDomain
		@cnames = @domain.cnames
	end

	def show
		@cname = getDomain.cnames.find @id
	end

	def create
		begin
			getDomain.cnames.create! params.require(:cname).permit(:name, :to_name)
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
			@cname = getDomain.cnames.find @id
			@cname.destroy!
			@success = true
		rescue
			@success = false
		end
		respond_to do |format|
			format.html { redirect_to :back }
		end
	end
end
