<<<<<<< HEAD
# frozen_string_literal: true

=======
>>>>>>> venue
require 'faker'

FactoryBot.define do
  factory :venue do
<<<<<<< HEAD
  end
end
=======
    name { Faker::Mountain.name }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
  end
end
>>>>>>> venue
