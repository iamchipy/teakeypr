class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.references :project, null: false, foreign_key: true
      t.text :description
      t.text :notes
      t.datetime :deadline
      t.boolean :completed

      t.timestamps
    end
  end
end
