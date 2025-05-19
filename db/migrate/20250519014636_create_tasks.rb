class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.integer :project_id
      t.boolean :completed
      t.text :notes
      t.datetime :due_date

      t.timestamps
    end
  end
end
