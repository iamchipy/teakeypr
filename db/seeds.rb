# db/seeds.rb
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# db/seeds.rb

puts "Seeding data..."

# Create Users
user = User.find_or_create_by!(email: "hire@johndavidbasson.com") do |u|
  u.password = "FREDDY5fee4mats-gray"
  u.password_confirmation = "FREDDY5fee4mats-gray"
  u.name = "Testing User" # Optionally assign name if you want it
end

# Create Projects
project = Project.find_or_create_by!(name: "Alpha Project") do |p|
  p.description = "The first project"
end

# Associate user with project (using the join table)
project.users << user unless project.users.include?(user)

# Create Tasks for Project
task1 = Task.find_or_create_by!(name: "Initial Task", project: project) do |t|
  t.description = "This is the initial task of the Alpha Project"
  t.completed = false
end

# Create more tasks (if needed)
task2 = Task.find_or_create_by!(name: "Design the layout", project: project) do |t|
  t.description = "Create wireframes for the website"
  t.completed = false
end

# Assign the user to tasks (many-to-many relationship)
task1.users << user unless task1.users.include?(user)
task2.users << user unless task2.users.include?(user)

# Create Time Entries for the user (associating them with tasks)
time_entry1 = TimeEntry.create!(
  start_time: Time.now,
  end_time: Time.now + 1.hour,
  user: user,
  task: task1,
  note: "Worked on initial task"
)

time_entry2 = TimeEntry.create!(
  start_time: Time.now + 1.hour,
  end_time: Time.now + 2.hours,
  user: user,
  task: task2,
  note: "Worked on design layout"
)

puts "Seeding complete!"
