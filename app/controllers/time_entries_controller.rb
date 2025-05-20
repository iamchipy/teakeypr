# app/controllers/time_entries_controller.rb
class TimeEntriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_time_entry, only: %i[show edit update destroy]

  def index
    @time_entries = current_user.time_entries.includes(task: :project)
  end

  def new
    @time_entry = TimeEntry.new
    @projects = current_user.projects.includes(:tasks)
  end

  def create
    @time_entry = current_user.time_entries.new(time_entry_params)

    if @time_entry.save
      redirect_to list_time_entries_path, notice: 'Time entry logged!'
    else
      @projects = current_user.projects.includes(:tasks)
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def show; end

  def update
    if @time_entry.update(time_entry_params)
      redirect_to @time_entry, notice: 'Time entry was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @time_entry.destroy
    redirect_to time_entries_path, notice: 'Time entry was successfully destroyed.', status: :see_other
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

  def set_time_entry
    @time_entry = current_user.time_entries.find(params[:id])
  end

  def time_entry_params
    params.require(:time_entry).permit(:start_time, :end_time, :description, :task_id, :notes)
  end
end
