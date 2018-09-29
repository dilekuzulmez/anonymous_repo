//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require metismenu/dist/metisMenu.min.js
//= require bootstrap-colorpicker/dist/js/bootstrap-colorpicker.min.js
//= require datatables.net/js/jquery.dataTables.js
//= require datatables.net-bs/js/dataTables.bootstrap.js
//= require summernote/dist/summernote.js
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-datepicker
//= require select2
//= require jquery_nested_form
//= require Chart.bundle
//= require chartkick
//= require_tree .

$(function() {
  var defaultDateFormat = 'dd/m/yyyy';

  var defaultTimePickerConfig = {
    useCurrent : true,
    sideBySide : true,
    format : 'DD/MM/YYYY HH:mm',
  };
  $('.datetimepicker').datetimepicker(defaultTimePickerConfig);

  var withMinDatePicker = $('.datetimepicker.from_current');
  if (withMinDatePicker.length > 0) {
    withMinDatePicker.data('DateTimePicker').minDate(moment());
  }

  $('.birthday_input').datepicker({
    defaultViewDate : {year : 1990, month : 04, day : 25},
    format : defaultDateFormat,
  });

  $('.promotion_date').datepicker({
    format : defaultDateFormat
  });

  $('.input-daterange').datepicker({
    format : defaultDateFormat,
  });

  $('select:not(.typical_select)').select2({
    theme : 'bootstrap',
  });

  $(document).ready(function(){
    $('#data-tables').DataTable({
      paging: false,
      info: false,
      ordering: false
    });
  })

  $(document).ready(function() {
    return $('[data-provider="summernote"]').each(function() {
      return $(this).summernote({
        toolbar: [
          // [groupName, [list of button]]
          ['para', ['ul', 'ol']],
          ['insert', ['link', 'picture']],
          ["style", ["style","bold", "italic", "underline"]]
        ]
      });
    });
  });

  $(document).ready(function() {
    $('a > blockquote').hide();
    $('a > pre').hide();
  });
});

$('#check_code').on('click', function(e){
  e.preventDefault();
  var match_id = $("#checkin_match").val();
  var hash_key = $("#checkin_code").val();
  $.ajax({
    type: 'POST',
    url: '/check_qr_code/',
    data: {
      "match_id": match_id,
      "hash_key": hash_key
    },
    success: function(data) {
      var info = '<tr><td>'+ data.id+'</td><td>'+ data.order_price+'</td><td>'+ data.quantity+'</td><td>'+ data.customer_name+'</td><td>'+ data.ticket_type+'</td><td>'+ data.paid+'</td></tr>'
      if (data.paid == false) {
        $('#submit-checkin').attr('disabled', 'disabled');
      } else {
        $('#submit-checkin').removeAttr('disabled');
      }
      $("#qr_info").modal('show');      
      $("#qr_table_info > tbody").html(info);
    },
    error: function(data) {
      alert(data.responseText);
    }
  })
})

$('#submit-checkin').click(function(){
  $('#checkin_form').submit();
})

