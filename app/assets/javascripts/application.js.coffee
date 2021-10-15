#= require rails-ujs
#= require turbolinks
#= require jquery
#= require jquery_ujs
#= require_self
#= require activestorage

$(document).on 'turbolinks:load', ->
  # pagination
  if $('.pagination').length
    $(window).scroll ->
      return if(window.pagination_loading)

      url = $('.pagination .next_page').attr('href')
      if url &&  $(window).scrollTop() > $(document).height() - $(window).height() - 50
        window.pagination_loading = true

        $('.pagination').text('Fetching more events...')
        $.getScript(url).always -> window.pagination_loading = false
    $(window).scroll()

  # delete.js
  document.body.addEventListener 'ajax:success', (event) ->
    $('#' + event.detail[0].id).remove()
    return
  document.body.addEventListener 'ajax:error', (event) ->
    alert event.detail[0].error
    return

  # map.js
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

  # add_attributes
  existing_performer_html = '<select class="form-control is-valid select required" id="existing_performer" name="event[performer_id]">' +
    +$('select')[0].innerHTML + '</select>'
  new_performer_html = '<input class="form-control is-valid string required" type="text" name="event[performer_name]" id="new_performer">'

  $("#create").on 'click', (event) ->
    event.preventDefault()
    $("#create").replaceWith('<a id="choose" href="#">Choose performer</a>')
    $('#existing_performer').replaceWith(new_performer_html)
    return
  $("#choose").on 'click', (event) ->
    event.preventDefault()
    $("#choose").replaceWith('<a id="create" href="#">Create performer</a>')
    $('#new_performer').replaceWith(existing_performer_html)
    return
  return
