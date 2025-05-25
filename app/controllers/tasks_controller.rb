# app/controllers/tasks_controller.rb
class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  include AccessControl

  # Add this block near the top of the controller
  rescue_from ActiveRecord::RecordNotFound do
    respond_to do |format|
      format.html do
        redirect_to tasks_path, alert: "Task not found."
      end

      format.turbo_stream do
        flash[:alert] = "Task not found."
        redirect_to tasks_path, status: :see_other
      end

      format.json do
        render json: { error: "Task not found." }, status: :not_found
      end
    end
  end

  # GET /tasks or /tasks.json
  def index
    @tasks = collect_accessible_tasks
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    # this allows auto filling of task ID when provided
    @task = Task.new(project_id: params[:project_id])
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated." }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    if @task.time_entries.exists?
      respond_to do |format|
        format.html { redirect_to tasks_path, alert: "Cannot delete task with time entries." }
        format.json { render json: { error: "Cannot delete task with time entries." }, status: :unprocessable_entity }
        format.turbo_stream do
          redirect_to tasks_path, alert: "Cannot delete task with time entries. (turbo)"
        end
      end
    else
      @task.destroy
      respond_to do |format|
        format.html { redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed." }
        format.json { head :no_content }
        format.turbo_stream do
          # redirect_to tasks_path, status: :see_other, alert: "Task was successfully destroyed. (turbo)"
          render turbo_stream: turbo_stream.remove(@task)
        end
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:name, :project_id, :description, :notes, :deadline, :completed, user_ids: [], time_entry_ids: [])
    end
end
