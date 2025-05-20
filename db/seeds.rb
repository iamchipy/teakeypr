# This file should ensure the existence of records required to run the application in every environment (production,
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
  u.password = "shine*arun2major5HARDY"
  u.password_confirmation = "shine*arun2major5HARDY"
end

# Create Projects
project = Project.find_or_create_by!(name: "Alpha Project") do |p|
  p.description = "The first project"
end

# Associate user with project
project.users << user unless project.users.include?(user)

# Create Tasks
Task.find_or_create_by!(name: "Initial Task", project: project)

puts "Seeding complete!"
