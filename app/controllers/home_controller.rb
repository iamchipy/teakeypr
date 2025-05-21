class HomeController < ApplicationController
  before_action :authenticate_user! 

  def index
    # helps set default tab for redirects
    if params[:tab].blank?
      redirect_to root_path(tab: 'time_entries') and return
    end

    # Fetch parameters or set defaults
    @tab = params[:tab] || "time_entries"
    @sort = params[:sort] || "created_at"
    @project_id = params[:project_id]
    @task_id = params[:task_id]

    # Fetch data based on the tab
    case @tab
    when "projects"
      @projects = current_user.projects
    when 'time_entries'
      @time_entries = filtered_time_entries
      @projects = current_user.projects
      @tasks = filtered_tasks
    when "tasks"
      @projects = current_user.projects
      @tasks = filtered_tasks
    else
      @time_entries = TimeEntry.includes(:task, :project).all
      @projects = Project.all
      @tasks = Task.all
    end
  end



  private

  def current_user_projects
    current_user.projects
  end

  def current_user_tasks
    scope = current_user.tasks.includes(:project)
    scope = scope.where(project_id: @project_id) if @project_id.present?
    scope = scope.order(@sort) if @sort.present?
    scope
  end

  def current_user_time_entries
    scope = current_user.time_entries.includes(:task)
    scope = scope.where(task_id: @task_id) if @task_id.present?
    scope = scope.joins(:task).where(tasks: { project_id: @project_id }) if @project_id.present?
    scope = scope.sort_by { |e| e.end_time - e.start_time } if @sort == 'duration'
    scope
  end

  # Filter tasks based on project_id, sort, and other params
  def filtered_tasks
    scope = current_user.tasks.includes(:project)
    scope = scope.where(project_id: @project_id) if @project_id.present?
    scope = scope.order(@sort) if @sort.present?
    scope
  end

  # Filter time entries based on task_id, project_id, and other params
  def filtered_time_entries
    scope = current_user.time_entries.includes(:task)
    scope = scope.where(task_id: @task_id) if @task_id.present?
    scope = scope.joins(:task).where(tasks: { project_id: @project_id }) if @project_id.present?
    scope = scope.order('end_time - start_time') if @sort == 'duration'
    scope
  end
end
