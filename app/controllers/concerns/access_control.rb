# app/controllers/concerns/access_control.rb
module AccessControl
  extend ActiveSupport::Concern

  def collect_accessible_tasks
    task_ids = current_user.assigned_tasks.pluck(:id) + current_user.project_tasks.pluck(:id)
    Task.where(id: task_ids.uniq)
  end

  def collect_accessible_projects
    project_ids = current_user.projects.pluck(:id) + current_user.projects_from_tasks.pluck(:id)
    Project.where(id: project_ids.uniq)
  end
end
