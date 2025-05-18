class TimeEntry < ApplicationRecord
  belongs_to :user
  belongs_to :task

  validates :start_time, :end_time, presence: true

  def duration
    end_time - start_time
  end
end
