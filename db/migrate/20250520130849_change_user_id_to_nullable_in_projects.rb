# db/migrate/TIMESTAMP_change_user_id_to_nullable_in_projects.rb
class ChangeUserIdToNullableInProjects < ActiveRecord::Migration[7.1]
  def change
    change_column_null :projects, :user_id, true
  end
end
