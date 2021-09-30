# frozen_string_literal: true

FactoryBot.define do
  factory :venue do
    sequence(:name) { |i| "#{Faker::Mountain.name}#{i}" }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
