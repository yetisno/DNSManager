class ProfilesController < ApplicationController
	include Loginable
	before_action :set_default

	def show
		@current_user = current_user
	end

	def update
		if params.require(:current_user)[:current_password].blank?
			@current_user.update! params.require(:current_user).permit(:email)
		else
			@current_user.update_with_password params.require(:current_user).permit(:email, :current_password,
			                                                        :password, :password_confirmation)
			sign_in @current_user, :bypass => true if @errors.blank?
		end
		error = ''
		error += "Current Password #{@errors[:current_password].first}\n" if @errors[:current_password]
		error += "Doesn't match Password\n" if @errors[:password_confirmation]
		error += "Password #{@errors[:password].first}\n" if @errors[:password]
		flash[:error] = error
		redirect_to profile_path
	end

	def set_default
		@current_user = current_user
		@errors = @current_user.errors.messages
	end

end
