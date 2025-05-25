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
  def self.from_omniauth(access_token)
    data = access_token.info
    user = find_by(email: data["email"])

    unless user
      user = create(
        name: data["name"],
        email: data["email"] || data["user"] || data["user_id"] || data["UID"],
        password: Devise.friendly_token[0, 20]
      )
    end

    user
  end

  def update_omniauth_hashes(auth_hash)
    self.last_omniauth_data ||= auth_hash.to_h
    self.current_omniauth_data = auth_hash.to_h
    save(validate: false)
  end
end
