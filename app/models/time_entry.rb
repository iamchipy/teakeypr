class TimeEntry < ApplicationRecord
  belongs_to :task
  belongs_to :user  # skip if you don't want direct ownership
end
