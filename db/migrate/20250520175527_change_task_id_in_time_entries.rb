class ChangeTaskIdInTimeEntries < ActiveRecord::Migration[6.0]
  def change
    change_column_null :time_entries, :task_id, true
  end
end
