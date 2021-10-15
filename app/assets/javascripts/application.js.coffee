#= require turbolinks
#= require jquery
#= require jquery_ujs
#= require_self
#= require activestorage


$(document).on 'turbolinks:load', ->

  if $('.pagination').length
    $(window).scroll ->
      return if(window.pagination_loading)

      url = $('.pagination .next_page').attr('href')
      if url &&  $(window).scrollTop() > $(document).height() - $(window).height() - 50
        window.pagination_loading = true

        $('.pagination').text('Fetching more events...')
        $.getScript(url).always -> window.pagination_loading = false
        return
    $(window).scroll()

  return
