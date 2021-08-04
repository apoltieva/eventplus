require 'faker'

FactoryBot.define do
  factory :event do
    title { Faker::String.random(length: 3..12) }
    description { Faker::Lorem.paragraph }
    artist { Faker::Name.name }
    start_time { Faker::Time.between(from: DateTime.now, to: DateTime.now + 1) }
    end_time { Faker::Time.between(from: DateTime.now + 2, to: DateTime.now + 3) }
    venue_id { 1 }
  end
end

