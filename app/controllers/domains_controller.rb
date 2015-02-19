class DomainsController < ApplicationController
	include Loginable
	before_action :set_domain, only: [:show, :edit, :update, :destroy]

	# GET /domains
	# GET /domains.json
	def index
		@domains = current_user.domains.all
	end

	# GET /domains/1
	# GET /domains/1.json
	def show
		@soa = @domain.soa
		@as = @domain.as
		@cnames = @domain.cnames
		@mxes = @domain.mxes
		@nameservers = @domain.nameservers
		@members = @domain.users
	end

	# GET /domains/new
	def new
	end

	# POST /domains
	# POST /domains.json
	def create
		respond_to do |format|
			begin
				ActiveRecord::Base.transaction do
					@domain = current_user.domains.create!(params.require(:domain).permit(:name, :description))
					@soa = params.require(:soa).permit(:contact, :refresh, :retry, :expire, :minimum)
					@soa[:contact] = @soa[:contact].gsub('@', '.')
					@soa[:domain_id] = @domain.id
					@soa[:name] = @domain.name
					@soa[:serial] = Time.now.to_i
					Soa.create!(@soa)
				end
				format.html { redirect_to @domain, notice: 'Domain was successfully created.' }
				format.json { render :show, status: :created, location: @domain }
			rescue Exception => ex
				format.html { render :new }
				format.json { render json: @domain.errors, status: :unprocessable_entity }
			end
		end
	end

	# PATCH/PUT /domains/1
	# PATCH/PUT /domains/1.json
	def update
		respond_to do |format|
			if @domain.update(domain_params)
				format.html { redirect_to @domain, notice: 'Domain was successfully updated.' }
				format.json { render :show, status: :ok, location: @domain }
			else
				format.html { render :edit }
				format.json { render json: @domain.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /domains/1
	# DELETE /domains/1.json
	def destroy
		@domain.destroy
		respond_to do |format|
			format.html { redirect_to domains_url, notice: 'Domain was successfully destroyed.' }
			format.json { head :no_content }
		end
	end

	private
	def set_domain
		if current_user.admin
			@domain = Domain.friendly.find(params[:id])
		else
			@domain = current_user.domains.friendly.find(params[:id])
		end

	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def domain_params
		params.require(:domain).permit(:name, :description)
	end

end
