# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  devise :omniauthable, omniauth_providers: %i[google_oauth2 discord]

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks
  has_many :time_entries, dependent: :destroy
  has_many :tasks, through: :projects

  # app/models/user.rb
  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data["email"]).first

      # Uncomment the section below if you want users to be created if they don't exist
      unless user
          user = User.create(name: data["name"],
             email: data["email"],
             password: Devise.friendly_token[0, 20]
          )
      end
      user
  end
end
