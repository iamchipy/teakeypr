# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: %i[show edit update destroy]

  def index
    @tasks = Task.includes(:project).all
  end

  def show; end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to @task, notice: 'Task was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'Task was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_path, notice: 'Task was successfully destroyed.', status: :see_other
  end

  def list
    @projects = current_user.projects.includes(:tasks)
    @time_entries = current_user.time_entries.includes(task: :project)

    if params[:project_id].present?
      @time_entries = @time_entries.joins(:task).where(tasks: { project_id: params[:project_id] })
    end

    if params[:start_date].present?
      @time_entries = @time_entries.where('start_time >= ?', params[:start_date].to_date.beginning_of_day)
    end

    if params[:end_date].present?
      @time_entries = @time_entries.where('end_time <= ?', params[:end_date].to_date.end_of_day)
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :project_id, :completed, :notes, :due_date)
  end
end
