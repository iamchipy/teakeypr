class TimeEntriesController < ApplicationController
  before_action :set_task, only: [:new, :create]
  before_action :authenticate_user!

  def new
    @time_entry = @task.time_entries.new
  end

  def create
    @time_entry = current_user.time_entries.new(time_entry_params)
    @time_entry.task = @task

    if @time_entry.save
      redirect_to project_task_path(@task.project, @task), notice: 'Time entry created!'
    else
      render :new
    end
  end

  private

  def set_task
    @task = Task.find(params[:task_id])
  end

  def time_entry_params
    params.require(:time_entry).permit(:start_time, :end_time, :description)
  end
end