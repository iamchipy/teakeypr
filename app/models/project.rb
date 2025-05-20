# app/models/project.rb
class Project < ApplicationRecord
  has_and_belongs_to_many :users
  has_many :tasks, dependent: :destroy

  accepts_nested_attributes_for :tasks, allow_destroy: true

  validates :name, presence: true
end
