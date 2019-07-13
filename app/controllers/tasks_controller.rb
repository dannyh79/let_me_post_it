class TasksController < ApplicationController
  include SessionsHelper
  before_action :require_login
  before_action :find_task, only: [:show, :edit, :update, :destroy]
  after_action :include_user, only: [:index]

  def index
    @tasks = current_user.tasks.sorted_by("created_at_asc").page(params[:page]).per(8)
    
    case
      # sort
    when params[:created_at] != nil
      @tasks = current_user.tasks.sorted_by("created_at_#{params[:created_at]}").page(params[:page]).per(8)
    when params[:end_time] != nil
      @tasks = current_user.tasks.sorted_by("end_time_#{params[:end_time]}").page(params[:page]).per(8)
    when params[:priority] != nil
      @tasks = current_user.tasks.sorted_by("priority_#{params[:priority]}").page(params[:page]).per(8)

      # search
    when params[:title] != nil || params[:status] != nil
      case
        # search by title
      when params[:status] == ""
        @tasks = current_user.tasks.by_title(params[:title]).order(status: :asc).page(params[:page]).per(8)
        
        # search by status
      when params[:title] == ""
        @tasks = current_user.tasks.by_status(params[:status]).page(params[:page]).per(8)

        # search by both title and status
      when params[:title] != "" && params[:status] != ""
        @tasks = current_user.tasks.by_title_and_status(params[:title], params[:status]).page(params[:page]).per(8)
      end
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: t('.notice')
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to tasks_path, notice: t('.notice')
    else
      render :edit
    end
  end

  def destroy
    if @task
      @task.destroy
      redirect_to tasks_path, notice: t('.notice')
    else
      redirect_to (request.referer || tasks_path), alert: t('.alert')
    end
    
  end

  private

  def task_params
    params.require(:task).permit(:title, :start_time, :end_time, :priority, :status, :description, :user_id)
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def include_user
    @tasks = @tasks.includes(:user)
  end
end
