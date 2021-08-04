require 'faker'

FactoryBot.define do
  factory :venue do
    name { Faker::Mountain.name }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end