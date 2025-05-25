# app/models/project.rb
class Project < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :tasks   # taking out to fix project auto removing , dependent: :destroy

  accepts_nested_attributes_for :tasks, allow_destroy: true

  validates :name, presence: true

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
