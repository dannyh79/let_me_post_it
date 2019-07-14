class Admin::UsersController < Admin::BaseController
  before_action :find_user, only: [:show, :edit, :destroy]

  def index
    @users = User.order(created_at: :asc).page(params[:page]).per(8)
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
    @user = User.find_by_email(params[:user][:email])
    
    @user.update(user_params)
    redirect_to admin_users_path, notice: t('.notice')
  end

  def destroy
    @user.destroy

    if user_deleted?
      redirect_to admin_users_path, notice: t('.notice')
    else
      redirect_to (request.referer || admin_users_path), alert: t('admin.users.destroy.alert')
    end
  end

  private
  
  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role)
  end

  def user_deleted?
    true if not User.find_by(id: @user.id)
  end
end
