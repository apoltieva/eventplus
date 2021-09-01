class VenueDecorator < ApplicationDecorator
  delegate :latitude, :longitude

  def location
    if latitude && longitude
      Geocoder.search("#{object.latitude},#{object.longitude}").first.address
    else
      false
    end
  end

  def coordinates
    "#{object.latitude}° latitude, #{object.longitude}° longitude"
  end
end
