class AddCurrentOmniauthDataToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :current_omniauth_data, :jsonb
  end
end
