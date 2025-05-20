# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable
  has_and_belongs_to_many :projects
  has_many :time_entries, dependent: :destroy
  has_many :tasks, through: :projects
end