# app/models/user.rb
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  devise :omniauthable, omniauth_providers: %i[google_oauth2 discord]

  has_and_belongs_to_many :projects
  has_and_belongs_to_many :tasks
  has_many :time_entries, dependent: :destroy
  has_many :tasks, through: :projects


  def self.from_omniauth(access_token)
      data = access_token.info
      user = User.where(email: data["email"]).first

      unless user
          user = User.create(name: data["name"],
             email: data["email"] || data["user"] || data["user_id"]|| data["UID"],
             password: Devise.friendly_token[0, 20]
          )
      end
      user
  end

  # handles updating stored omniAuth data
  def update_omniauth_hashes(auth_hash)
    self.last_omniauth_data = self.last_omniauth_data || auth_hash.to_h
    self.current_omniauth_data = auth_hash.to_h
    save(validate: false)  # SKIPS VALIDATION
  end
end
