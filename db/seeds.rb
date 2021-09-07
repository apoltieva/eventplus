# frozen_string_literal: true

DESCRIPTIONS = File.read('db/descriptions.txt').split("\n\n\n")
Venue.delete_all
Event.delete_all
Performer.delete_all
Listing.delete_all
Order.delete_all
10.times do
  Venue.create!(name: Faker::Mountain.name,
                latitude: rand(50.0..51.0),
                longitude: rand(30.0..31.0),
                max_capacity: rand(10000))
  Performer.create!(name: Faker::Name.name)
end

DESCRIPTIONS.each do | descr |
  Event.create!(title: Faker::Movie.title,
                description: descr,
                performers: Performer.all.sample(rand(1...4)),
                start_time: Faker::Time.between(from: DateTime.new(2021, 8, 3, 4, 5, 6),
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

Event.all.each do |e|
  (1..3).each do |i|
    e.pictures.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ['events', 'parties'])),
                      filename: "#{i}.png")
  end
end
Venue.all.each do |v|
  (1..3).each do |i|
    v.pictures.attach(io: URI.open(Faker::LoremFlickr.image(search_terms: ['mountains'])),
      filename: "#{i}.png")
  end
end
# 5.times do
#   Admin.create!(email: Faker::Internet.email, password: "123456", confirmed_at: Time.now, role: 1)
# end
