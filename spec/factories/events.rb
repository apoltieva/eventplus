# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :event do
    title { Faker::Movie.title }
    description { Faker::Lorem.paragraph }
    artist { Faker::Name.name }
    start_time { Faker::Time.between(from: DateTime.new(2001,2,3,4,5,6), to: DateTime.new(2021,2,3,4,5,6)) }
    end_time { Faker::Time.between(from: DateTime.new(2022,2,3,4,5,6), to: DateTime.new(2023,2,3,4,5,6)) }
    association :venue
  end
end
