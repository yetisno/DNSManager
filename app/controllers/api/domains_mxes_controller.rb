class Api::DomainsMxesController < ApiDomainController
	include Loginable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def index
		@mxes = getDomain.mxes
	end

	def show
		@mx = getDomain.mxes.find @id
	end

	def create
		begin
			getDomain.mxes.create! params.require(:domains_mx).permit(:name, :to_priority, :to_name)
			@success = true
		rescue
			@success = false
		end
	end

	def destroy
		@mx = getDomain.mxes.find @id
		begin
			@mx.destroy!
			@success = true
		rescue
			@success = false
		end
	end
end
