$(function() {
  'use strict';

  var showField = function(custom_field, hidden_field_id) {
    custom_field.show();
    var custom_field_input = custom_field.find(hidden_field_id);
    custom_field_input.disabled = false;
  };

  var enableField = function(text_field) {
    text_field.prop('disabled', false);
  };

  var customFieldListener = function(dropdown_id, option_selected) {
    option_selected = option_selected || 'Other...';

    $(dropdown_id).change(function(e) {
      if( $(this).find("option:selected").text() == option_selected ) {
        var custom_field = $(this).closest('.form-group').find('.select_custom_field')
        showField(custom_field);
        enableField(custom_field.find('input[disabled=disabled]'));
      }
    });
  };

  var updateCustomFields = function() {
    customFieldListener('select#person_building_id');
    customFieldListener('select#person_city_id');
  };

  var selectOtherOption = function() {
    $('.select_custom_field > input').each(function() {
      if( $( this ).val() != '' ) {
        enableField( $( this ) );
        var parent = $( this ).closest('.form-group');
        showField( parent.find('.select_custom_field') );
        parent.find('select > option').last().prop('selected', true);
      };
    });
  };

  // Update on page load
  updateCustomFields();
  selectOtherOption();
});
