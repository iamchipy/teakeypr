class ProjectsController < ApplicationController
  before_action :authenticate_user!  # Ensure the user is authenticated

  def index
    @projects = current_user.projects  # Only show the current user's projects
  end

  def show
    @project = Project.find(params[:id])
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.projects.new(project_params)
    if @project.save
      redirect_to project_path(@project), notice: "Project successfully created!"
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      redirect_to project_path(@project), notice: "Project successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    @project.destroy
    redirect_to projects_path, notice: "Project successfully deleted."
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end
end
