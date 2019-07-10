class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    case 
    when params[:created_at] != ""
      case params[:created_at]
      when "asc"
        @tasks = Task.created_at_asc
      when "desc"
        @tasks = Task.created_at_desc
      end      
    when params[:end_time] != ""
      case params[:end_time]
      when "asc"
        @tasks = Task.end_time_asc
      when "desc"
        @tasks = Task.end_time_desc
      end
    end

    # When none of the sort methods is chosen 
    if @tasks.nil?
      @tasks = Task.all
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
      redirect_to (request.referer || tasks_path), alert: 'Failed: could not find/delete the task'
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
