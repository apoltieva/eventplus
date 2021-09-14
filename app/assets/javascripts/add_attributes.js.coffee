$(document).on 'turbolinks:load', ->
  existing_performer_html = '<select class="form-control is-valid select required" id="existing_performer" name="event[performer_id]">' +
    + $('select')[0].innerHTML + '</select>'
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
