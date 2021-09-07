$(document).on 'turbolinks:load', ->
  document.body.addEventListener 'ajax:success', (event) ->
    $('#' + event.detail[0].id).hide()
    return
  document.body.addEventListener 'ajax:error', (event) ->
    alert event.detail[0].error
    console.log(1)
    return
  return
