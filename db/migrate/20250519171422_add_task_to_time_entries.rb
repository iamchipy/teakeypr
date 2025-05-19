class AddTaskToTimeEntries < ActiveRecord::Migration[8.0]
  def change
    add_reference :time_entries, :task, foreign_key: true
  end
end
