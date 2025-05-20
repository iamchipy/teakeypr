# db/migrate/xxxxxx_create_tasks.rb
class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.boolean :completed, default: false
      t.datetime :due_date
      t.text :notes
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
