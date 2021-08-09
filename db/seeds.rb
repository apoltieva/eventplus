# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)\
#
if Venue.none?
  10.times do
    Venue.create!(name: Faker::Mountain.name,
                  latitude: rand(50..51),
                  longitude: rand(30..31))
  end
end

if Event.none?
  10.times do
    Event.create!(title: Faker::Movie.title,
                  description: Faker::Lorem.paragraph,
                  artist: Faker::Name.name,
                  start_time: Faker::Time.between(from: DateTime.new(2021, 9, 3, 4, 5, 6), to: DateTime.new(2021, 12, 3, 4, 5, 6)),
                  end_time: Faker::Time.between(from: DateTime.new(2022, 2, 3, 4, 5, 6), to: DateTime.new(2023, 2, 3, 4, 5, 6)),
                  venue_id: Venue.all.sample.id)
  end
end
