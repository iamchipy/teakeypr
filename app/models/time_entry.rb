# app/models/time_entry.rb
class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :task, optional: true

  delegate :project, to: :task, allow_nil: true

  validates :user, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  before_save :set_duration

  private

  def set_duration
    self.duration = (end_time && start_time) ? end_time - start_time : 0
  end
end
