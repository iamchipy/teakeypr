# app/models/task.rb
class Task < ApplicationRecord
  belongs_to :project, optional: true  # This allows task_id to be nil
  has_and_belongs_to_many :users

  # to guard deletions at model level
  has_many :time_entries, dependent: :restrict_with_error
  # used for Anoy tracking
  visitable :ahoy_visit

  validates :name, presence: true
end
