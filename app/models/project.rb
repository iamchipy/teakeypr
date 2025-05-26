# app/models/project.rb
class Project < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :tasks, dependent: :restrict_with_error

  accepts_nested_attributes_for :tasks # NOT USED  , allow_destroy: true

  validates :name, presence: true

  # used for Anoy tracking
  visitable :ahoy_visit

  # POSSIBLE later improvement if I want to stop orphans
  # before_destroy :ensure_no_tasks_exist
  # private
  # def ensure_no_tasks_exist
  #   if tasks.exists?
  #     errors.add(:base, "Cannot delete project with existing tasks")
  #     throw(:abort)
  #   end
  # end
end
