# frozen_string_literal: true

FactoryBot.define do
  factory :university do
    name { Faker::University.name }
    category { %w[public private].sample }
    state { Faker::Address.state }
    region { %w[Norte Nordeste Centro-Oeste Sudeste Sul].sample }
    abbreviation { Faker::University.suffix }
    logo_url { Faker::Internet.url }
  end
end
