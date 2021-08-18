# frozen_string_literal: true

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
                  start_time: Faker::Time.between(from: DateTime.new(2021, 9, 3, 4, 5, 6),
                                                  to: DateTime.new(
                                                    2021, 12, 3, 4, 5, 6
                                                  )),
                  end_time: Faker::Time.between(from: DateTime.new(2022, 2, 3, 4, 5, 6),
                                                to: DateTime.new(2023,
                                                                 2, 3, 4, 5, 6)),
                  venue_id: Venue.all.sample.id,
                  total_number_of_tickets: rand(100000),
                  ticket_price_cents: rand(100000)
                  )
  end
end
Event.all.each do |e|
  e.pictures.purge
  (1..3).each do |i|
    e.pictures.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ['events', 'parties'])),
                      filename: "#{i}.png")
  end
end
Venue.all.each do |v|
  v.pictures.purge
  (1..3).each do |i|
    v.pictures.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ['mountains'])),
      filename: "#{i}.png")
  end
end
5.times do
  Admin.create!(email: Faker::Internet.email, password: "123456", confirmed_at: Time.now, role: 1)
end
