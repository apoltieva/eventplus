# frozen_string_literal: true

class VenuesWithDistanceFinder
  def self.call(coords)
    Venue.near(
      coords, 20_000, units: :km, select: 'venues.id'
    ).each_with_object({}) { |v, h| h[v.id] = v.distance }
  end
end
