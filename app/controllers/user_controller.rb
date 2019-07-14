class UserController < ApplicationController
  include SessionsHelper

  before_action :find_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if valid_email? && valid_password?
      @user.save
      redirect_to root_path, notice: t('.notice')
    else
      render :new
    end
  end

  def edit
  end

  def update
    user = User.find_by_email(params[:user][:email])
    if valid_password? && user.authenticate(params[:user][:old_password])
      @user.update(user_params)
      redirect_to tasks_path, notice: t('.notice')
    else
      render :edit
    end
  end

  private
  
  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
