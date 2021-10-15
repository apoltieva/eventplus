#= require rails-ujs
#= require turbolinks
#= require jquery
#= require jquery_ujs
#= require_self
#= require activestorage

$(document).on 'turbolinks:load', ->
  document.body.addEventListener 'ajax:success', (event) ->
    $('#' + event.detail[0].id).remove()
    return
  document.body.addEventListener 'ajax:error', (event) ->
    alert event.detail[0].error
    return
