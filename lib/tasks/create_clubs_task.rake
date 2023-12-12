require 'faker'

namespace :data do
  desc "Create a Club for each University"
  task create_clubs: :environment do
    University.all.each do |university|
      club = Club.find_or_initialize_by(name: "Atlética #{university.abbreviation}", university_id: university.id)
      if club.save && club.new_record?
        ClubHonor.create!(title: "Campeão Geral", year: 2019, description: "Invícto",club_id: club.id)
        ClubAthlete.create!(name: Faker::Name.name, achievements: "O melhor", joined_at: 8.years.ago, left_at: 4.years.ago, club_id: club.id)
        ClubContent.create!(content: Faker::Lorem.paragraphs(number: 20).sum, club_id: club.id)
        puts "Club #{club.name} created!"
      else
        puts "Club already exists or there was an error"
      end
    end
  end
end
