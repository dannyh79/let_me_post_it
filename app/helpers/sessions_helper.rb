module SessionsHelper
  def current_user
    return if not session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end
end