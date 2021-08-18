# frozen_string_literal: true

require 'faker'

FactoryBot.define do
  factory :event do
    title { Faker::Movie.title }
    description { Faker::Lorem.paragraph }
    artist { Faker::Name.name }
    start_time do
      Faker::Time.between(
        from: DateTime.new(2001),
        to: DateTime.new(2021)
      )
    end
    end_time do
      Faker::Time.between(
        from: DateTime.new(2022),
        to: DateTime.new(2023)
      )
    end
    association :venue
  end
end
