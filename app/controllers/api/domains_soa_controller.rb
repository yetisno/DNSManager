class Api::DomainsSoaController < ApiDomainController
	include Loginable
	before_action do
		@user = current_user
		@id = params[:id] unless params[:id].blank?
	end

	def show
		@soa = getDomain.soa
	end

	def create
		begin
			getDomain.soa.create! params.require(:domains_soa).permit(:name, :contact, :serial, :refresh, :retry, :expire, :minimum)
			@success = true
		rescue
			@success = false
		end
	end

	def update
		begin
			getDomain.soa.update! params.require(:domains_soa).permit(:name, :contact, :serial, :refresh, :retry, :expire, :minimum)
			@success = true
		rescue
			@success = false
		end
	end

	def destroy
		@soa = getDomain.soa
		begin
			@soa.destroy!
			@success = true
		rescue
			@success = false
		end
	end
end
