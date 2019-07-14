class Admin::UsersController < ApplicationController
  include SessionsHelper

  before_action :require_login
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    # @users = User.all.includes(:tasks).page(params[:page]).per(8)
    @users = User.all.page(params[:page]).per(8)
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if valid_email? && valid_password?
      @user.save
      redirect_to admin_users_path, notice: t('.notice')
    else
      render :new
    end
  end

  def show
    @tasks = @user.tasks.page(params[:page]).per(8)
  end

  def edit
  end

  def update
    user = User.find_by_email(params[:user][:email])
    if valid_password? && user.authenticate(params[:user][:old_password])
      @user.update(user_params)
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: 'User was successfully destroyed啦.'
  end

  private
  
  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
