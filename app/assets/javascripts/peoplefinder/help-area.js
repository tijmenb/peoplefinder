/* global $ */

$('.help-content').hide();
$('.help-toggle').click(function(){
  $(this).toggleClass('open').next('.help-content').slideToggle('slow');
});

if( $('.edit-links > a').size() == 0 ){
  $('.edit-links').hide();
}
