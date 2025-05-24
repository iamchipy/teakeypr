class TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: %i[ show edit update destroy ]
  before_action :authorize_user!, only: %i[show edit update destroy]  # redirects defensively
  before_action :authenticate_user!

  # GET /time_entries or /time_entries.json
  def index
    # user scoped search
    @time_entries = current_user.time_entries
  end

  # GET /time_entries/1 or /time_entries/1.json
  def show
    @time_entry = TimeEntry.includes(:user, task: :project).find(params[:id])
  end

  # GET /time_entries/new
  def new
    # this allows auto filling of task ID when provided
    @time_entry = TimeEntry.new(task_id: params[:task_id])
  end

  # GET /time_entries/1/edit
  def edit
  end

  # POST /time_entries or /time_entries.json
  def create
    @time_entry = TimeEntry.new(time_entry_params)
    @time_entry.user_id ||= current_user.id  # Set current_user as default if not provided

    respond_to do |format|
      if @time_entry.save
        format.html { redirect_to time_entries_path(@time_entry), notice: "Time entry was successfully created." }
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
      params.require(:time_entry).permit(:start_time, :end_time, :user_id, :task_id, :note, :users, :tasks)
    end

    def authorize_user!
      redirect_to root_path, alert: "Not authorized" unless @time_entry.user == current_user
    end
end
