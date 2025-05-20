# db/migrate/xxxxxx_create_time_entries.rb
class CreateTimeEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :time_entries do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.text :description
      t.text :notes
      t.references :user, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
