# db/migrate/20250526145010_add_ahoy_visit_to_projects_tasks_time_entries_users.rb
class AddAhoyVisitToProjectsTasksTimeEntriesUsers < ActiveRecord::Migration[8.0]
  def change
    add_reference :projects, :ahoy_visit
    add_reference :tasks, :ahoy_visit
    add_reference :time_entries, :ahoy_visit
    add_reference :users, :ahoy_visit
  end
end
