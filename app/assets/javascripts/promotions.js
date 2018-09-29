function is_season_checked() {
  if($("#promo_is_season").is(':checked')) {
    $("#matches").prop('selectedIndex', -1)
    $(".select2-selection__rendered").first().empty()
    $("#matches").prop('disabled', true)
  }
  else
    $("#matches").prop('disabled', false)
}

$(document).ready(function() {
  is_season_checked()

  $(document).on('change', '#promo_is_season', function() {
    is_season_checked()
  })
})
