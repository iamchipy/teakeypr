# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :project
  has_many :time_entries, dependent: :destroy

  validates :name, presence: true
end
