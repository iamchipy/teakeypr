# app/models/user.rb
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



  # All projects user has access to (directly or via tasks)
  def all_accessible_projects
    (projects + projects_from_tasks).uniq
  end

  # OmniAuth setup
  def self.from_omniauth(auth)
    user = find_by(email: auth.info["email"])

    unless user
      user = create(
        name: auth.info.name,
        email: auth.info.email || auth.info.user || auth.info.user_id || auth.uid,
        password: Devise.friendly_token[0, 20],
        provider: auth.provider,
        uid: auth.uid
      )
    else
      # Ensure these are updated for existing users too
      user.update(provider: auth.provider, uid: auth.uid)
    end

    user.update_omniauth_hashes(auth)
    user.update_user_image(user.auth_hash_to_image_url(auth))

    user.save
    # return user obj
    user
  end



  # private

  def update_omniauth_hashes(auth_hash)
    self.last_omniauth_data ||= auth_hash.to_h
    self.current_omniauth_data = auth_hash.to_h
  end

  def update_user_image(url)
    self.image_url = url
  end

  def auth_hash_to_image_url(auth_hash)
      provider = auth_hash["provider"]
      image_url =
          case provider
          when "google_oauth2"
              auth_hash["info"]["image"]
          when "discord"
              uid = auth_hash["uid"]
              avatar = auth_hash["extra"]["raw_info"]["avatar"]
              avatar ? "https://cdn.discordapp.com/avatars/#{uid}/#{avatar}.png" : "https://cdn.discordapp.com/embed/avatars/0.png"
          end
  end
end
