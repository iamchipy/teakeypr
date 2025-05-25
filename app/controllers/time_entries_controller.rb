# app/controllers/time_entries_controller.rb
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

  # def search
  #   query = params[:q].to_s.downcase
  #   entries = TimeEntry.where("LOWER(name) LIKE ?", "%#{query}%").limit(20)
  #   render json: entries.map { |e| { id: e.id, name: e.name, duration: e.duration.to_i } }
  # end

  # def search
  #   term = params[:q]
  #   exclude_ids = params[:exclude_ids].presence || []

  #   results = TimeEntry
  #     .where.not(id: exclude_ids)
  #     .where("name ILIKE ?", "%#{term}%")
  #     .limit(20)

  #   render json: results.select(:id, :name)
  # end


  def search
    term = params[:q].to_s.strip

    # better parsing since I've not locked in var type in JS
    exclude_ids_raw = params[:exclude_ids]
    exclude_ids = exclude_ids_raw.is_a?(Array) ? exclude_ids_raw.map(&:to_i) : exclude_ids_raw.to_s.split(",").map(&:to_i)

    # just for debug and tracking
    Rails.logger.debug "Search term: '#{term}'"
    Rails.logger.debug "Exclude IDs: #{exclude_ids.inspect}"

    time_entries = TimeEntry.where.not(id: exclude_ids)
    time_entries = time_entries.where("name ILIKE ?", "%#{term}%") if term.present?

    render json: time_entries.limit(20).map { |t| { id: t.id, text: "#{t.name} #{t.duration}" } }
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_entry
      @time_entry = TimeEntry.find(params[:id])
    end



    # Only allow a list of trusted parameters through.
    def time_entry_params
      params.require(:time_entry).permit(:start_time, :name, :end_time, :user_id, :task_id, :note, :users, :tasks)
    end

    def authorize_user!
      redirect_to root_path, alert: "Not authorized" unless @time_entry.user == current_user
    end
end
