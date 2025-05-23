# app/models/time_entry.rb
class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true

  delegate :project, to: :task, allow_nil: true

  validates :user, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
