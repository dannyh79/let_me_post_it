class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]
  def index
    # for search & sort
    case 
      # search
    when params[:title] != nil || params[:status] != nil
      case
      when params[:title] != "" && params[:status] != ""
        @tasks = Task.by_title_and_status(params[:title], params[:status]).page(params[:page]).per(8)
      when params[:title] != "" && params[:status] == ""
        @tasks = Task.by_title(params[:title]).order(status: :asc).page(params[:page]).per(8)
      when params[:title] == "" && params[:status] != ""
        @tasks = Task.by_status(params[:status]).page(params[:page]).per(8)
      end

      # sort
    when params[:created_at] != ""
      case params[:created_at]
      when "asc"
        @tasks = Task.created_at_asc.page(params[:page]).per(8)
      when "desc"
        @tasks = Task.created_at_desc.page(params[:page]).per(8)
      end      
    when params[:end_time] != ""
      case params[:end_time]
      when "asc"
        @tasks = Task.end_time_asc.page(params[:page]).per(8)
      when "desc"
        @tasks = Task.end_time_desc.page(params[:page]).per(8)
      end
    when params[:priority] != ""
      case params[:priority]
      when "asc"
        @tasks = Task.priority_asc.page(params[:page]).per(8)
      when "desc"
        @tasks = Task.priority_desc.page(params[:page]).per(8)
      end
    end

    # When none of the search conditionals or sort methods is present 
    if @tasks.nil?
      @tasks = Task.page(params[:page]).per(8)
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
    params.require(:task).permit(:title, :description, :start_time, :end_time, :status)
  end

  def find_task
    @task = Task.find(params[:id])
  end
end
