class CreateTimeEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :time_entries do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true
      t.text :note

      t.timestamps
    end
  end
end
