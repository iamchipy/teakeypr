# db/migrate/20250525004558_add_name_to_time_entries.rb
class AddNameToTimeEntries < ActiveRecord::Migration[8.0]
  def change
    add_column :time_entries, :name, :string, default: "Unlabeled"
    add_index :time_entries, :name
  end
end
