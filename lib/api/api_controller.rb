class ApiController < ApplicationController
	protect_from_forgery with: :null_session, if: lambda { request.format.json? }
end