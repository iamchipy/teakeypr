class AddLastOmniauthDataToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :last_omniauth_data, :jsonb
  end
end
