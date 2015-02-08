module Loginable
	extend ActiveSupport::Concern
	included do
		before_action :loginCheck
	end

	def loginCheck
		if current_user.blank?
			respond_to do |format|
				format.html {
					authenticate_user!
				}
			end
		end
	end
end
