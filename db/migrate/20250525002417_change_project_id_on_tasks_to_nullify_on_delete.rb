# db/migrate/20250525002417_change_project_id_on_tasks_to_nullify_on_delete.rb
class ChangeProjectIdOnTasksToNullifyOnDelete < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :tasks, :projects
    add_foreign_key :tasks, :projects, on_delete: :nullify
  end
end
