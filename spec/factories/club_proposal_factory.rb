# frozen string literal: true

FactoryBot.define do
  factory :club_proposal do
    proposed_club_name { Faker::Company.name }
    proposed_club_description { Faker::Lorem.paragraph }
    proposed_club_year_of_foundation { Faker::Number.between(from: 1900, to: 2020) }
    proposed_club_logo_url { Faker::Internet.url }
    user
    university
    approved { false }
  end
end
