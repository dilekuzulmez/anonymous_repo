var QrTicketTypes = {};

$(document).ready(function(){
  $('#qr_code_home_team_id').on('change', function(){
    var team_id = $('#qr_code_home_team_id').val();
    var qr_code_ticket_type = $('#qr_code_ticket_type');
    if (team_id){
      getTicketTypes(team_id, function(data){
        setTicketTypes(qr_code_ticket_type, data)
      });
    }
    
  })

  function setTicketTypes(element, ticketTypes) {
    var options;
  
    if (!ticketTypes) {
      options = $("<option value=''>--- Select ---</option>");
      $(element).html(options);
    } else {
      options = ticketTypes.map(function(type) {
        return $('<option value="' + type.code + '">' + type.code + '</option>');
      });
      $(element).html(options);
      element.prepend("<option value=''>--- Select ---</option>").val('');
    }
  }

  function getTicketTypes(team_id, callback){
    var request = $.ajax({
      url: '/qr_code/' + team_id + '/ticket_types.json',
      dataType: 'json'
    });
  
    request.done(function(data) {
      QrTicketTypes[team_id] = data;
      if(callback){
        callback(data);
      } 
    });
  
    request.fail(function(jqXHR, textStatus) {
      console.log('get ticket types failed: ' + textStatus);
    });
  }
})