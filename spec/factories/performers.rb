# frozen_string_literal: true

FactoryBot.define do
  factory :performer do
    name { Faker::Name.name }
  end
end
