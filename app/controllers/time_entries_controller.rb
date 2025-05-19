class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /time_entries/new
  def new
    @time_entry = TimeEntry.new
    @projects = current_user.projects.includes(:tasks)
  end

  def list
    @projects = current_user.projects.includes(:tasks)
    @time_entries = current_user.time_entries.includes(task: :project)

    if params[:project_id].present?
      @time_entries = @time_entries.joins(:task).where(tasks: { project_id: params[:project_id] })
    end

    if params[:start_date].present?
      @time_entries = @time_entries.where("start_time >= ?", params[:start_date].to_date.beginning_of_day)
    end

    if params[:end_date].present?
      @time_entries = @time_entries.where("end_time <= ?", params[:end_date].to_date.end_of_day)
    end
  end

  # GET /time_entries or /time_entries.json
  def index
    @time_entries = TimeEntry.all
  end

  # GET /time_entries/1 or /time_entries/1.json
  def show
  end

  # GET /time_entries/1/edit
  def edit
  end

  # POST /time_entries or /time_entries.json
  def create
    @time_entry = current_user.time_entries.new(time_entry_params)

    if @time_entry.save
      redirect_to list_time_entries_path, notice: 'Time entry logged!'
    else
      @projects = current_user.projects.includes(:tasks)
      render :new
    end
  end

  # PATCH/PUT /time_entries/1 or /time_entries/1.json
  def update
    respond_to do |format|
      if @time_entry.update(time_entry_params)
        format.html { redirect_to @time_entry, notice: "Time entry was successfully updated." }
        format.json { render :show, status: :ok, location: @time_entry }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_entries/1 or /time_entries/1.json
  def destroy
    @time_entry.destroy!

    respond_to do |format|
      format.html { redirect_to time_entries_path, status: :see_other, notice: "Time entry was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_entry
      @time_entry = TimeEntry.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def time_entry_params
      params.expect(time_entry: [ :user_id, :start_time, :end_time, :description, :task, :notes ])
    end
end
