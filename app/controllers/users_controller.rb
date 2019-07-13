class UsersController < ApplicationController
  # before_action :find_user, only: [:show, :edit, :update, :destroy]

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    
    if email_valid? && password_confirmed?
      @user.save
      redirect_to root_path, notice: t('.notice')
    else
      redirect_to signup_path, alert: t('sessions.create.alert')
    end
  end

  # def edit
  # end

  # def update
  #   user = User.find_by_email(params[:email])
  #   if user && user.authenticate(params[:password])
  #     @user.update(user_params)
  #     redirect_to tasks_path, notice: 'User was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # def destroy
  #   @user.destroy
  #   redirect_to root_path, notice: 'User was successfully destroyed.'
  # end

  private
  
  # def find_user
  #   @user = User.find(params[:id])
  # end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def password_confirmed?
    true if params[:user][:password] != "" && params[:user][:password] == params[:user][:password_confirmation]
  end

  def email_valid?
    true if params[:user][:email].match(/\A([\w\.%\+\-]+)@([\w\-]+\.)+([a-zA-Z]{2,})\z/i)
  end
end
