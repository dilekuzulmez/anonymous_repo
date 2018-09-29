$('#combo_matches').on('change', function(){
  var combo_matches = $('#combo_matches').val();
  var combo_ticket_type = $('#combo_ticket_type');
  getTicketType(combo_matches, function(data){
    setTicketType(combo_ticket_type, data)
  })
})

function getTicketType(match_ids, callback) {
  var request = $.ajax({
    url: '/combos/ticket_type_matches/' + match_ids,
    dataType: 'json'
  })
  request.done(function(data){
    if (callback) {
      callback(data);
    }
  })
}

function setTicketType(element, data) {
  var options = "";
  if (!data) {
    options += "<option value=''>--- Select ---</option>";
    $(element).html(options);
  } 
  else {
    data.forEach(function(item) {
      options += '<option value="' + item + '">' + item + '</option>';
    });
    console.log(options);
    $(element).html(options);
    element.prepend("<option value=''>--- Select ---</option>").val('');
  }
}
