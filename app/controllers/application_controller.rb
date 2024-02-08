class ApplicationController < ActionController::Base
	before_action :authenticate_user!

	# include Pundit
	include Pundit::Authorization
	protect_from_forgery

	after_action :user_activity

	rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

	include Pagy::Backend 

	before_action :set_global_variables, if: :user_signed_in?
	  def set_global_variables
	    # navbar search
	    @ransack_courses = Course.ransack(params[:courses_search], search_key: :courses_search)
	  end


	include PublicActivity::StoreController #save current_user using gem public_activity

	private

	  def user_not_authorized #pundit
	    flash[:alert] = "You are not authorized to perform this action."
	    redirect_to(request.referrer || root_path)
	  end

	  def user_activity
	    current_user.try :touch
	  end
end
