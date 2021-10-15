#= require turbolinks
#= require jquery
#= require jquery_ujs
#= require_self
#= require activestorage


$(document).ajaxSuccess ( event, request, settings ) ->
  $('#' + JSON.parse(request.responseText).id).remove()
  return
$(document).ajaxError ( event, request, settings ) ->
  alert(JSON.parse(request.responseText).error)
  return
