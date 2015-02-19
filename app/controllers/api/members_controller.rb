class Api::MembersController < ApiDomainController
	include Loginable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@members = getDomain.users
	end

	def show
		@member = getDomain.users.find @id
	end

	def create
		begin
			getDomain.user_domain_maps.create! params.require(:member).permit(:user_id)
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
			@relation = getDomain.user_domain_maps.find_by user_id: params[:id]
			@relation.destroy!
			@success = true
		rescue
			@success = false
		end
		respond_to do |format|
			format.json { render status: @success ? :ok : :bad_request }
			format.html { redirect_to :back }
		end
	end
end
