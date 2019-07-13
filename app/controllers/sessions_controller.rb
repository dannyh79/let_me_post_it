class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: t('.notice')
    else
      redirect_to new_session_path, alert: t('sessions.create.alert')
    end
  end
  
  def destroy
    if session[:user_id]
      session[:user_id] = nil
      redirect_to root_path, notice: t('.notice')
    else
      redirect_to (request.referer || root_path)
    end
  end
end