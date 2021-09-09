//= require rails-ujs
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require_self
//= require activestorage

$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});
