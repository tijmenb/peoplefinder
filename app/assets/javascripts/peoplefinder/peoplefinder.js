/* global $, document, TeamAutocomplete */

$(function() {
  $(document).on('click', '#add_membership', function(e) {
    e.preventDefault();
    $.ajax({
      url: this,
      success: function(data) {
        var el_to_add = $(data).html();
        $('#memberships').append(el_to_add);
        TeamAutocomplete
          .enhance( $('.team-select')
          .not('.team-select-enhanced')[0]);
      }
    });
  });

  $(document).on('click', 'a.remove-new-membership', function(e) {
    e.preventDefault();
    $(this).parents('.membership').remove();
  });

  $('select#person_building_id').change(function(e) {
    e.preventDefault();
    if( $(this).find("option:selected").text() == 'Other...' ) {
      var custom_field = $(this).closest('.form-group').find('.select_custom_field');
      custom_field.show();
      var custom_field_input = custom_field.find('#person_building_attributes_address')[0];
      custom_field_input.value = '';
      custom_field_input.disabled = false;
    }
  });

  $('select#person_city_id').change(function(e) {
    e.preventDefault();
    if( $(this).find("option:selected").text() == 'Other...' ){
      var custom_field = $(this).closest('.form-group').find('.select_custom_field');
      custom_field.show();
      var custom_field_input = custom_field.find('#person_city_attributes_name')[0];
      custom_field_input.value = '';
      custom_field_input.disabled = false;
    }
  });

  $(document).on('click', 'a.show-editable-fields', function(e) {
    e.preventDefault();
    $(this).closest('.editable-summary').hide();
    $(this).closest('.editable-container').children('.editable-fields').show();
  });
});
