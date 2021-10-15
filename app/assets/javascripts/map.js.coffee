#= require turbolinks
#= require jquery
#= require jquery_ujs
#= require activestorage

$(document).on 'turbolinks:load', ->
  initMap = ->
    location = {
      lat: parseFloat(document.getElementById('venue_latitude').value),
      lng: parseFloat(document.getElementById('venue_longitude').value)
    }

    map = new (google.maps.Map)(document.getElementById('map'),
      zoom: 14
      center: location)

    marker = new (google.maps.Marker)(
      position: location
      map: map)
    return

  initMap()
  return
