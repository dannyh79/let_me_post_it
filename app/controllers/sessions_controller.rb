class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: "Logged in!"
    else
      flash.now[:alert] = "Email or password is invalid"
      render "new"
    end
  end
  
  def destroy
    if session[:user_id]
      session[:user_id] = nil
      redirect_to root_path, notice: "Logged out!"
    else
      redirect_to (request.referer || root_path)
    end
  end
end