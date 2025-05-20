# app/controllers/projects_controller.rb
class ProjectsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, only: %i[show edit update destroy]

  def index
    @projects = current_user.projects
  end

  def show; end

  def new
    @project = Project.new
    @project.tasks.build
  end

  def create
    @project = current_user.projects.build(project_params)

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @project.tasks.build if @project.tasks.empty?
  end

  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project successfully deleted.', status: :see_other
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def project_params
    params.require(:project).permit(
      :name,
      :description,
      user_ids: [],
      tasks_attributes: %i[id title description _destroy]
    )
  end
end
