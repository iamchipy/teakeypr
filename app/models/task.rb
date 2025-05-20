class Task < ApplicationRecord
  belongs_to :project, optional: true  # This allows task_id to be nil
  has_and_belongs_to_many :users
end
