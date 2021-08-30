//= require rails-ujs
//= require turbolinks
//= require jquery
//= require jquery_ujs
//= require_self
//= require activestorage
//= require moment
//= require bootstrap-datetimepicker
//= require pickers

$(document).ready(function() {
  if ($('.pagination').length) {
    $(window).scroll(function() {
      var url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > $(document).height() - $(window).height() - 50) {
        $('.pagination').text("Please Wait...");
        return $.getScript(url);
      }
    });
    return $(window).scroll();
  }
});
