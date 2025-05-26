# db/migrate/20250526023102_remove_avatar_column_from_users.rb
class RemoveAvatarColumnFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :avatar, :string
  end
end
