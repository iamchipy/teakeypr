class TimeEntriesController < ApplicationController
  # before_action :authenticate_user! # TODO should get this in but next sprint
  # helper ActionView::Helpers::DateHelper # TODO learn to use this for math

  before_action :set_time_entry, only: %i[ show edit update destroy ]

  # GET /time_entries or /time_entries.json
  def index
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:task_id])
    @time_entries = @task.time_entries
  end

  # GET /time_entries/1 or /time_entries/1.json
  def show
  end

  # GET /time_entries/all
  def list
    @time_entries = current_user.time_entries.includes(task: :project)
  end

  # GET /time_entries/new
  def new
    @time_entry = TimeEntry.new
  end

  # GET /time_entries/1/edit
  def edit
  end

  # POST /time_entries or /time_entries.json
  def create
    @time_entry = TimeEntry.new(time_entry_params)

    respond_to do |format|
      if @time_entry.save
        format.html { redirect_to @time_entry, notice: "Time entry was successfully created." }
        format.json { render :show, status: :created, location: @time_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
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
      params.expect(time_entry: [ :start_time, :end_time, :description, :task, :notes ])
    end
end
