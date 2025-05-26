# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /projects or /projects.json
  def index
    # user scoped search
    @projects = current_user.projects
  end

  # GET /projects/1 or /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    @project = Project.new(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: "Project was successfully created." }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: "Project was successfully updated." }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    if @project.tasks.exists?
      respond_to do |format|
        format.html { redirect_to tasks_path, alert: "Cannot delete Project with Tasks still assigned." }
        format.json { render json: { error: "Cannot delete Project with Tasks still assigned." }, status: :unprocessable_entity }
        format.turbo_stream do
          redirect_to project_path, alert: "Cannot delete Project with Tasks still assigned. (turbo)"
        end
      end
    else
      @project.destroy
      respond_to do |format|
        format.html { redirect_to tasks_path, status: :see_other, notice: "Project was successfully destroyed." }
        format.json { head :no_content }
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(@project)
        end
      end
    end
  end












  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def project_params
      # params.expect(project: [ :name, :description ])
      params.require(:project).permit(:name, :description, task_ids: [], user_ids: [])
    end
end
