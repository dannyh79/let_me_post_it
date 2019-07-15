class TasksController < ApplicationController
  include SessionsHelper

  before_action :require_login
  before_action :find_task, only: [:show, :edit, :update, :destroy]
  after_action :include_user, only: [:index]

  def index
    @tasks = current_user.tasks.sorted_by("created_at_asc").page(params[:page]).per(8)
    
    # (to be looking into the implementation of query object so this dirty mess can be simplified)
    case
      # sort
    when params[:created_at] != nil
      @tasks = current_user.tasks.sorted_by("created_at_#{params[:created_at]}").page(params[:page]).per(8)
    when params[:end_time] != nil
      @tasks = current_user.tasks.sorted_by("end_time_#{params[:end_time]}").page(params[:page]).per(8)
    when params[:priority] != nil
      @tasks = current_user.tasks.sorted_by("priority_#{params[:priority]}").page(params[:page]).per(8)

      # search
    when params[:title] != nil || params[:status] != nil || params[:tag] != nil
      case
        # search by both title and status
      when params[:title] != "" && params[:status] != "" && params[:tag].empty?
        @tasks = current_user.tasks.by_title_and_status(params[:title], params[:status]).page(params[:page]).per(8)

        # search by title/status and tag
      when title_or_status && params[:tag] != ""
        case
        when params[:title] != "" && params[:status] != ""
          @tasks = current_user.tasks.by_tag(params[:tag]).by_title_and_status(params[:title], params[:status]).page(params[:page]).per(8)
        when params[:title] != ""
          @tasks = current_user.tasks.by_tag(params[:tag]).by_title(params[:title]).page(params[:page]).per(8)
        when params[:status] != ""
          @tasks = current_user.tasks.by_tag(params[:tag]).by_status(params[:status]).page(params[:page]).per(8)
        end
        
        # search by title (when there's no tag param present)
      when params[:status] == "" && params[:tag].empty?
        @tasks = current_user.tasks.by_title(params[:title]).page(params[:page]).per(8)
        
        # search by status (when there's no tag param present)
      when params[:title] == "" && params[:tag].empty?
        @tasks = current_user.tasks.by_status(params[:status]).page(params[:page]).per(8)

        # search by tag
      when params[:tag] != ""
        @tasks = current_user.tasks.by_tag(params[:tag]).page(params[:page]).per(8)
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
    params.require(:task).permit(:title, :start_time, :end_time, :priority, :status, :description, :user_id, :tag_list)
  end

  def find_task
    if Task.find(params[:id]).user_id == current_user.id || admin?
      @task = current_user.tasks.find(params[:id])
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  def include_user
    @tasks = @tasks.includes(:user)
  end

  def title_or_status
    true if params[:title] != "" || params[:status] != ""
  end
end
