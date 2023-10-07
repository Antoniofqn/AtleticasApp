# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Create a default admin user
admin = Administrator.find_by(email: "admin@atleticas.com")
Administrator.create!(email: "admin@atleticas.com", password: "common12345", password_confirmation: "common12345") unless admin

# Create a default user
user = User.find_by(email: "user@atleticas.com")
User.create!(email: "user@atleticas.com", password: "common12345", password_confirmation: "common12345", first_name: "User", last_name: "User") unless user

# Create a default university
University.find_or_create_by!(name: "Universidade de São Paulo", state: "São Paulo", region: "Sudeste", category: 0, abbreviation: "USP", logo_url: 'wwww.google.com')

# Create a default club
Club.find_or_create_by!(name: "Atlética da USP", university_id: 1)

# Create a default club user
ClubUser.find_or_create_by!(club_id: 1, user_id: 1)

# Create a default club proposal
ClubProposal.find_or_create_by!(proposed_club_name: "Atlética da USP 2", university_id: 1, user_id: 1)
