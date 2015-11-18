$(function() {
  'use strict';

  var customFieldListener = function(dropdown_id, hidden_field_id, option_selected) {
    option_selected = option_selected || 'Other...';

    $(dropdown_id).change(function(e) {

      if( $(this).find("option:selected").text() == option_selected ) {
        var custom_field = $(this).closest('.form-group').find('.select_custom_field');
        custom_field.show();
        var custom_field_input = custom_field.find(hidden_field_id)[0];
        custom_field_input.disabled = false;
      }
    });
  };

  var updateCustomFields = function() {
    customFieldListener('select#person_building_id', '#person_custom_building');
    customFieldListener('select#person_city_id', '#person_custom_city');
  };

  // Update on page load
  updateCustomFields();
});
