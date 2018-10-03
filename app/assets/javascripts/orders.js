var matchTicketTypesCache = {};
var seasonTicketTypesCache = {};

$(document).ready(function() {
  $(document).on('click', '.show_qr', function() {
    $('#qrModal').modal('show').find('.modal-body').load($(this).data('href'));
  })  
  

  $(document).on('change', '#match_select', function() {
    var matchId = $(this).val();
    if (!matchId) {
      return;
    }

    var ticketTypeSelects = $(this).closest('.fields').find('.ticket_types');

    if (!matchTicketTypesCache[matchId]) {
      getTicketTypes(matchId, function(data) {
        setTicketTypeOptions(ticketTypeSelects, data);
      });
    } else {
      var data = matchTicketTypesCache[matchId];
      setTicketTypeOptions(ticketTypeSelects, data);
    }
  });

  $('#team_select').on('change', function() {
    var teamId = $('#team_select').val();
    if (!teamId) {
      return;
    }

    var ticketTypeSelects = $('select.ticket_types');

    if (!seasonTicketTypesCache[teamId]) {
      getSeasonTicketTypes(teamId, function(data) {
        setTicketTypeOptions(ticketTypeSelects, data);
      });
    } else {
      var data = seasonTicketTypesCache[teamId];
      setTicketTypeOptions(ticketTypeSelects, data);
    }
  });

  // When new order detail is added, assign options for ticket type select
  $('#orders_form').on('nested:fieldAdded', function(event) {
    // var field = event.field;
    // var select = field.find('.ticket_types');
    // var matchId = $('#match_select').val();
    // var teamId = $('#team_select').val();
    // if(teamId){
      // var ticketTypes = seasonTicketTypesCache[teamId];
      // setTicketTypeOptions(select, ticketTypes);
    // }
  });

  // Update value for price
  $(document).on('change', '.ticket_types', function() {

    var ticketTypeId = $(this).val();
    var matchId = $(this).closest('.fields').find('#match_select').val();
    var teamId = $('#team_select').val();
    if(matchId){
      var ticketType = findTicketType(matchId, ticketTypeId);
      $(this)
        .parents('.panel-body')
        .find('.unit_price')
        .val(ticketType.price);
    }else if(teamId){
      var request = $.ajax({
        url: '/seasons/total_price?home_team_id=' + teamId + '&ticket_type_id=' + ticketTypeId + '&' + window.location.search.substring(1),
        dataType: 'json',
      });

      request.done(function(data) {
        $('#order_total_price').val(data);
      });

      request.fail(function(jqXHR, textStatus) {
        console.log('get total price failed: ' + textStatus);
      });
    }
  });

  $('#promotion_code').on('blur', function() {
    var promoCode = $(this).val();

    if (promoCode.length > 0) {
      findPromotion($(this).val());
    }
  });

$('#promotion_code').on('blur', function() {
  var promoCode = $(this).val();

  if (promoCode.length > 0) {
    findPromotion($(this).val());
  }
});

  $('#kind_select').on('change', function() {
    var value = $(this).val();
    if (value === 'invitation') {
      $('#promotion_code').attr('disabled', true);
    } else {
      $('#promotion_code').attr('disabled', false);
    }
  });

  // Trigger change manually upon page finished rendering to get and show data for ticket types
  var matchId = $('#match_select').val();
  if (matchId) {
    getTicketTypes($('#match_select').val());
  }

  $('#kind_select').trigger('change');
});

function findPromotion(promotionCode) {
  var matchId = $('#match_select').val();
  var customerId = $('#order_customer_id').val();
  var homeTeamId = $('#team_select').val();
  var paramIsSeason = ''
  if (homeTeamId != null && homeTeamId.length > 0) {
    paramIsSeason = '&&is_season=true'
  }
  var paramsMatchId = ''
  if (matchId != null && matchId.length > 0) {
    paramsMatchId = '&&match_id=' + matchId
  }

  var request = $.ajax({
    url: '/promotions/find/' + encodeURIComponent(promotionCode) + '?customer_id=' + customerId + paramsMatchId + paramIsSeason
  });

  request.done(function(promo) {
    $('#discount_type').val(promo.discount_type);
    $('#discount_amount').val(promo.discount_amount);
  });

  request.fail(function(jqXHR, textStatus) {
    console.log('get promotion failed: ' + textStatus);

    $('#discount_type').val('INVALID PROMO CODE');
  });
}

function findTicketType(matchId, ticketTypeId) {
  var ticketTypes = matchTicketTypesCache[matchId];
  return ticketTypes.find(function(type) {
    return type.id == ticketTypeId;
  });
}

function setTicketTypeOptions(element, ticketTypes) {
  var options;

  if (!ticketTypes) {
    options = $("<option value=''>--- Select ---</option>");
    $(element).html(options);
  } else {
    options = ticketTypes.map(function(type) {
      return $('<option value="' + type.id + '">' + type.code + '</option>');
    });
    $(element).html(options);
    element.prepend("<option value=''>--- Select ---</option>").val('');
  }

  var price = ticketTypes.length > 0 ? ticketTypes[0].price : '';
  $(element)
    .parents('.panel-body')
    .find('.unit_price')
    .val(price);
}

// Get remote ticket types for the match
function getTicketTypes(matchId, callback) {
  var request = $.ajax({
    url: '/matches/' + matchId + '/ticket_types.json',
    dataType: 'json'
  });

  request.done(function(data) {
    matchTicketTypesCache[matchId] = data;
    if (callback) {
      callback(data);
    }
  });

  request.fail(function(jqXHR, textStatus) {
    console.log('get ticket types failed: ' + textStatus);
  });
}

// Get remote ticket types for the season
function getSeasonTicketTypes(teamId, callback) {
  var request = $.ajax({
    url: '/teams/' + teamId + '/ticket_types.json?' + window.location.search.substring(1),
    dataType: 'json',
  });

  request.done(function(data) {
    seasonTicketTypesCache[teamId] = data;
    if (callback) {
      callback(data);
    }
  });

  request.fail(function(jqXHR, textStatus) {
    console.log('get ticket types failed: ' + textStatus);
  });
}
