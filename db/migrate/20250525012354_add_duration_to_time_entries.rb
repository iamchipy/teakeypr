# db/migrate/20250525012354_add_duration_to_time_entries.rb
class AddDurationToTimeEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :time_entries, :duration, :float, default: 0.0, null: false
    add_index :time_entries, :duration

    reversible do |dir|
      dir.up do
        TimeEntry.reset_column_information
        TimeEntry.find_each do |entry|
          if entry.start_time && entry.end_time
            entry.update_column(:duration, entry.end_time - entry.start_time)
          end
        end
      end
    end
  end
end
