# app/models/time_entry.rb
class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :task

  # validates :start_time, :end_time, presence: true
  validate :end_after_start

  private

  def end_after_start
    return if end_time.blank? || start_time.blank?
    errors.add(:end_time, 'must be after the start time') if end_time < start_time
  end
end
