class CreateTimeEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :time_entries do |t|
      t.datetime :start_time
      t.date :end_time

      t.timestamps
    end
  end
end
