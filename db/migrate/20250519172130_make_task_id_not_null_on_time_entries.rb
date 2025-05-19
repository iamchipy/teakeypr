class MakeTaskIdNotNullOnTimeEntries < ActiveRecord::Migration[8.0]
  def change
    change_column_null :time_entries, :task_id, false
  end
end
