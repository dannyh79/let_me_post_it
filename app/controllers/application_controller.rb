class ApplicationController < ActionController::Base 
  private
 
  def require_login
    redirect_to new_session_path, alert: t('sessions.login.alert') if not logged_in?
  end

  def logged_in?
    true if session[:user_id]
  end
end
