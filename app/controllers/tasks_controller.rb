class TasksController < ApplicationController
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    # for search & sort
    case 
      # sort
    when params[:title] != nil || params[:status] != nil
      case
      when params[:title] != "" && params[:status] != ""
        @tasks = Task.by_title_and_status(params[:title], params[:status])
      when params[:title] != "" && params[:status] == ""
        @tasks = Task.by_title(params[:title]).order(status: :asc)
      when params[:title] == "" && params[:status] != ""
        @tasks = Task.by_status(params[:status])
      end

      # search
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

    # case params[:title] != nil || params[:status] != nil
    # when params[:title] != "" && params[:status] != ""
    #   @tasks = Task.by_title_and_status(params[:title], params[:status])
    # when params[:title] != "" && params[:status] == ""
    #   @tasks = Task.by_title(params[:title]).order(status: :asc)
    # when params[:title] == "" && params[:status] != ""
    #   @tasks = Task.by_status(params[:status])
    # end

    # case params[:created_at] != nil || params[:end_time] != nil
    # when params[:created_at] != ""
    #   case params[:created_at]
    #   when "asc"
    #     @tasks = Task.created_at_asc
    #   when "desc"
    #     @tasks = Task.created_at_desc
    #   end      
    # when params[:end_time] != ""
    #   case params[:end_time]
    #   when "asc"
    #     @tasks = Task.end_time_asc
    #   when "desc"
    #     @tasks = Task.end_time_desc
    #   end
    # end

    # When none of the search conditionals or sort methods is present 
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
