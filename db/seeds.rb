# frozen_string_literal: true
require 'faker'

DESCRIPTIONS = File.read('db/descriptions.txt').split("\n\n\n")

if Venue.none?
  10.times do
    Venue.create!(name: Faker::Mountain.name,
                  latitude: rand(50.0..51.0),
                  longitude: rand(30.0..31.0),
                  max_capacity: rand(10000))
  end
end

if Performer.none?
  10.times do
    Performer.create!(name: Faker::Name.name)
  end
end

performers = Performer.all
if Event.none?
  DESCRIPTIONS.each do | descr |
    Event.create!(title: Faker::Movie.title,
                  description: descr,
                  performer_id: performers.sample.id,
                  start_time: Faker::Time.between(from: Time.now + 2.days,
                                                  to: Time.now + 10.days),
                  end_time: Faker::Time.between(from: Time.now + 11.days,
                                                to: Time.now + 12.days),
                  venue_id: Venue.all.sample.id,
                  total_number_of_tickets: rand(100000),
                  ticket_price_cents: rand(100000)
                  )
  end
end

Event.all.each do |e|
  if e.pictures.empty?
    (1..3).each do |i|
      e.pictures.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ['events', 'parties'])),
                        filename: "#{i}.png")
    end
  end
end
Venue.all.each do |v|
  if v.pictures.empty?
    (1..3).each do |i|
      v.pictures.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ['mountains'])),
        filename: "#{i}.png")
    end
  end
end
if Admin.none?
  5.times do
    Admin.create!(email: Faker::Internet.email, password: "123456", confirmed_at: Time.now, role: 1)
    end
end
