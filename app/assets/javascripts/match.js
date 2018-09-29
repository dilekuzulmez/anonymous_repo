var teamStadiumMaps = {};

function getHomeStadiumID(teamID) {
  if (teamStadiumMaps[teamID]) {
    $('.match_stadium_id').val(teamStadiumMaps[teamID]);
  }

  $.ajax({
    url: '/teams/' + teamID + '/home_stadium.json',
    success: function(data) {
      $('.match_stadium_id').val(data.id);
      teamStadiumMaps[teamID] = data.id;
    },
    error: function(res) {
      console.log(res);
    },
  });
}

$(function() {
  $('.home_team_select').on('change', function() {
    getHomeStadiumID(this.value);
  });

  $('#matches_filter label').on('click', function() {
    var value = $(this).find('input[name="match_filter"]').prop('id');

    $.ajax({
      url: '/matches.js?filter=' + value,
      success: function() {
        var searchParams = parseQueryParams();
        searchParams.filter = value;
        var newQuery = convertToQueryString(searchParams);
        var newurl = window.location.protocol + '//' + window.location.host + window.location.pathname + '?' + newQuery;
        window.history.pushState({ path: newurl }, '', newurl);
      },
    });
  });

  $('#selectSeason').on('change', function() {
    var seasonID = this.value;
    $.ajax({
      url: '/seasons/' + seasonID + '/season_time.json',
      success: function(data) {
        var duration = data.season.duration;
        var startDate = duration.split('...')[0];
        var endDate = duration.split('...')[1];
        rederDateTime(startDate, endDate);
      },
      error: function(res) {
        console.log(res);
      },
    });
  });

  function rederDateTime(startDate, endDate) {
    $('.datetimepicker').data("DateTimePicker").minDate(new Date(startDate));
    $('.datetimepicker').data("DateTimePicker").maxDate(new Date(endDate));
  }
});

function convertToQueryString(q) {
  var query = q || {};
  var params = [];
  var result = '';
  Object.keys(query).forEach(function(key) {
    params = params.concat(key + '=' + query[key]);
  });

  result = params.join('&');

  return result;
}

function parseQueryParams() {
  if (!window.location.search) {
    return {};
  }
  var query = window.location.search.substr(1);
  var result = {};
  query.split('&').forEach(function(part) {
    var item = part.split('=');
    result[item[0]] = item[1];
  });

  return result;
}
