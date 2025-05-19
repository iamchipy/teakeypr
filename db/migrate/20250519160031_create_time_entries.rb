class CreateTimeEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :time_entries do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.text :description
      t.integer :task
      t.text :notes

      t.timestamps
    end
  end
end
