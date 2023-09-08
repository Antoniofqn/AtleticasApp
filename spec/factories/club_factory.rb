# frozen_string_literal: true

FactoryBot.define do
  factory :club do
    name { Faker::Company.name }
    description { Faker::Lorem.paragraph }
    year_of_foundation { Faker::Number.between(from: 1900, to: 2020) }
    university_id { create(:university).id }
    logo_url { Faker::Internet.url }
  end
end
