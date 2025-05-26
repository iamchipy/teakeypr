# app/models/user.rb
require "open-uri"

class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
  devise :omniauthable, omniauth_providers: %i[google_oauth2 discord]

  # Direct associations
  has_and_belongs_to_many :projects                # via projects_users
  has_and_belongs_to_many :assigned_tasks,         # via tasks_users
                          class_name: "Task",
                          join_table: "tasks_users"

  has_many :time_entries, dependent: :destroy

  # Indirect associations
  has_many :project_tasks, through: :projects, source: :tasks

  # Projects indirectly accessible via task assignment
  has_many :projects_from_tasks, -> { distinct }, through: :assigned_tasks, source: :project

  has_one_attached :avatar  # ActiveStorage for profile images


  # All projects user has access to (directly or via tasks)
  def all_accessible_projects
    (projects + projects_from_tasks).uniq
  end

  # OmniAuth setup
  def self.from_omniauth(auth)
    # refactoring with find/init being a thing
    user = find_or_initialize_by(email: auth.info.email)

    # just update the profile everytime you sign in
    user.name = auth.info.name
    user.email=  auth.info.email || auth.info.user || auth.info.user_id || auth.uid
    user.password=  Devise.friendly_token[0, 20]
    user.provider = auth.provider
    user.uid = auth.uid
    user.last_omniauth_data = user.current_omniauth_data.presence
    user.current_omniauth_data = auth.to_h

    # new, adding avatare image cached via ActiveStorage
    # First we check if provider gave a URL
    img_url = user.auth_hash_to_image_url(auth)
    user.image_url = img_url.presence
    # now if we got a URL then lets try fetch it
    user.update_user_image!

    user.save!
    # return user obj
    user
  end



  # private

  def update_user_image!
    return unless self.image_url.present?
    begin
      downloaded_image = URI.open(self.image_url)
      self.avatar.attach(
        io: downloaded_image,
        filename: "avatar-#{self.uid}.jpg",
        content_type: downloaded_image.content_type || "image/jpeg"
      )
    rescue OpenURI::HTTPError => e
      Rails.logger.warn "Avatar download failed with HTTP error: #{e.message}"
    rescue SocketError => e
      Rails.logger.warn "Avatar download failed due to network issue: #{e.message}"
    rescue => e
      Rails.logger.error "Unexpected error while downloading avatar: #{e.message}"
    end
  end

  def auth_hash_to_image_url(auth_hash)
      case auth_hash["provider"]
      when "google_oauth2"
          auth_hash["info"]["image"]
      when "discord"
          uid = auth_hash["uid"]
          avatar = auth_hash["extra"]["raw_info"]["avatar"]
          avatar ? "https://cdn.discordapp.com/avatars/#{uid}/#{avatar}.png" : "https://cdn.discordapp.com/embed/avatars/0.png"
      end
  end
end
