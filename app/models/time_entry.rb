# app/models/time_entry.rb
class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true  # This allows task_id to be nil

  validates :user, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
