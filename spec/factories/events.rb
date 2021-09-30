# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title { Faker::Movie.title }
    description { Faker::Lorem.paragraph }
    performer
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
    total_number_of_tickets { Faker::Number.between(from: 1, to: 10_000) }
    venue
  end
end
