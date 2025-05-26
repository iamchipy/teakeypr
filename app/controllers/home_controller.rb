# app/controllers/home_controller.rb
class HomeController < ApplicationController
  include AccessControl
  before_action :authenticate_user!


  def index
    # Re-Enabling this because we want Time_Entries to auto-load when
    # we navigate here from another tab
    if params[:tab].blank?
      redirect_to root_path(tab: "time_entries") and return
    end

    # Fetch parameters or set defaults
    @tab = params[:tab].presence || "time_entries"
    @sort = params[:sort] || "created_at"
    @project_id = params[:project_id]
    @task_id = params[:task_id]

    # Fetch data based on the tab
    case @tab
    when "projects"
      @projects = filtered_projects
    when "time_entries"
      @time_entries = filtered_time_entries
      @projects = filtered_projects
      @tasks = filtered_tasks
    when "tasks"
      @projects = filtered_projects
      @tasks = filtered_tasks
    else
      @time_entries = TimeEntry.all
      @projects = Project.all
      @tasks = Task.all
    end
  end



  private

  def filtered_projects
    scope = collect_accessible_projects
    scope = scope.order(@sort) if @sort.present?
    scope
  end

  # Filter tasks based on project_id, sort, and other params
  def filtered_tasks
    # first we make sure to check for any tasks that user should have access to but is NOT
    # directly assigned but indirectly via a task
    scope = collect_accessible_tasks
    scope = scope.where(project_id: @project_id) if @project_id.present?
    scope = scope.order(@sort) if @sort.present?
    scope
  end

  # Filter time entries based on task_id, project_id, and other params
  def filtered_time_entries
    scope = current_user.time_entries # .includes(task: :project)
    scope = scope.where(task_id: @task_id) if @task_id.present?
    scope = scope.joins(:task).where(tasks: { project_id: @project_id }) if @project_id.present?

    if @sort == "duration"
      scope = scope.sort_by { |entry| entry.end_time - entry.start_time }
    else
      scope = scope.order(@sort) if @sort.present?
    end

    scope
  end
end
