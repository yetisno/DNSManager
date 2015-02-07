class AdminUsersController < ApplicationController
	before_action :loginCheck
	before_action :set_default
	before_action :check_admin
	before_action :set_user, only: [:show, :edit, :destroy, :update]

	# GET /admin_users
	# GET /admin_users.json
	def index
		@users = User.all
	end

	# GET /admin_users/1.json
	def show
		@domains = @user.domains.all;
	end

	# GET /admin_users/new
	def new
		@user = User.new
	end

	# GET /admin_users/1/edit
	def edit
	end

	# POST /admin_users
	# POST /admin_users.json
	def create
		@user = User.new(params.require(:user).permit(:username, :email, :admin, :password, :password_confirmation))
		@user.save
		if !@user.errors.blank?
			error = ''
			@user.errors.messages.each do |key, message|
				error += "#{key} #{message.first}\n"
			end
			flash[:error] = error
			redirect_to :back
		else
			redirect_to admin_user_index_path
		end
	end

	# PATCH/PUT /admin_users/1
	# PATCH/PUT /admin_users/1.json
	def update
		@errors = @user.errors.messages
		if params.require(:user)[:password].blank?
			pe = params.require(:user).permit(:email, :admin)
			@user.update! params.require(:user).permit(:admin)
		else
			@user.update! params.require(:user).permit(:email, :admin, :password, :password_confirmation)
		end
		error = ''
		error += "Doesn't match Password\n" if @errors[:password_confirmation]
		error += "Password #{@errors[:password].first}\n" if @errors[:password]
		flash[:error] = error
		redirect_to admin_user_index_path
	end

	def destroy
		if @user.id == @current_user.id
			flash[:error] = "Can't delete yourself."
			redirect_to admin_user_index_path
		else
			@user.destroy!
			redirect_to admin_user_index_path
		end
	end

	def set_user
		@user = User.find(params[:id])
	end

	def set_default
		@current_user = current_user
	end

	def check_admin
		redirect_to root if !@current_user.admin
	end
end

