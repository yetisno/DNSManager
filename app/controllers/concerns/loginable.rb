module Loginable
	extend ActiveSupport::Concern
	included do
		before_action :loginCheck
	end

	def loginCheck
		if current_user.blank?
			respond_to do |format|
				if isJson?
					format.json {
						render json: {success: false, doAction: 'login'}
					}
				else
					format.html {
						authenticate_user!
					}
				end
			end
		end
	end

	def isJson?
		request.content_type == 'application/json' || request.format.json?
	end
end
