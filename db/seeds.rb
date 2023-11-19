# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require 'csv'

# Create a default admin user
admin = Administrator.find_by(email: "admin@atleticas.com")
Administrator.create!(email: "admin@atleticas.com", password: "common12345", password_confirmation: "common12345") unless admin

# Create a default user
user = User.find_by(email: "user@atleticas.com")
User.create!(email: "user@atleticas.com", password: "common12345", password_confirmation: "common12345", first_name: "User", last_name: "User") unless user

# Create a default university
CSV.foreach(Rails.root.join('data', 'universities.csv'), headers: true) do |row|
  attributes = row.to_hash
  attributes["category"] == "0" ? attributes["category"] = :public : attributes["category"] = :private
  University.find_or_create_by!(attributes)
end

# Create a default club
Club.find_or_create_by!(name: "Atlética da USP", university_id: University.find_by(abbreviation: "USP").id)

# Create a default club user
ClubUser.find_or_create_by!(club_id: Club.last.id, user_id: 1)

# Create a default club proposal
ClubProposal.find_or_create_by!(proposed_club_name: "Atlética da USP 2", university_id: University.find_by(abbreviation: "USP").id, user_id: 1)
