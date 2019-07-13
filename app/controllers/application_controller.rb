class ApplicationController < ActionController::Base 
  private
 
  def require_login
    redirect_to root_path, alert: "You must be logged in to access this section" if not logged_in?
  end

  def logged_in?
    true if session[:user_id]
  end
end
