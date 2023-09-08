# frozen_string_literal: true

FactoryBot.define do
  factory :university do
    name { Faker::University.name }
    category { %w[public private].sample }
    state { 'Rio de Janeiro' }
    region { %w[Norte Nordeste Centro-Oeste Sudeste Sul].sample }
    abbreviation { Faker::University.suffix }
    logo_url { Faker::Internet.url }
  end
end
