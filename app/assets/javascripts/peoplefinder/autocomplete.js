/* global $, _ */

var TeamAutocomplete = (function (){
  var data = undefined;

  var TeamAutocomplete = {
    transformations: [
      // replace Ministry of Justice with MoJ
      function (o){
        if($.trim(o.innerHTML) !== 'Ministry of Justice'){
          o.innerHTML = o.innerHTML.replace('Ministry of Justice', 'MOJ');
        }
      }
    ],

    formatResults: function ( o ){
      var name, path = '';
      if( o.text === 'Ministry of Justice' ){
        name = 'Ministry of Justice';
        path = '<span class="hidden">Ministry of Justice</span>';
      }else{
        name = o.text.substring(0, o.text.indexOf('[') - 1);
        path = o.text.substring(o.text.indexOf('['));
      }

      if( path.length > 70 ){
        var p = path.slice(1, -1).replace('MOJ > ', '');

        path = _.reduce(p.split(' > ').reverse(), function (str, x){
          var nstr = x + ' > ' + str;
          return nstr.length > 70 ? str : nstr;
        });

        path = '[' + path + ']';
      }

      return $( '<span class="team-name">' +
                  name + '</span> <span class="team-path">' +
                  path + '</span>' );
    },

    runTransformations: function (o){
      $(o).find('option').map(function (i2, o2){
        // run each transformation
        $.each(TeamAutocomplete.transformations, function(i3, t){ t(o2); });
      });
    },

    enhance: function ( o ){
      TeamAutocomplete.runTransformations(o);

      $(o).select2({
        templateResult: TeamAutocomplete.formatResults
      }).addClass('team-select-enhanced');
    },

    enhance2: function ( o ){
      var $o = $(o);
      data = _.without(_.map( $o.find('option'), function ( x ){
        var m = x.innerHTML.match(/(.*) \[(.*)\]/);
        if( m != null ){
          var gs = m[2].split(' &gt; ');
          var group = gs[1] || gs[0];

          return { name: m[1], path: m[2], group: group, id: x.value };
        }

      }), undefined);

      $results = $('.team-select-search-results');
      TeamAutocomplete.render(data);

      var $input = $('.team-select-search-box');

      $input.keyup(function (){
        var query = $input.val();
        var list  = _.filter(data, function (x){
          return x.name.toLowerCase().match(query);
        });

        TeamAutocomplete.render(list);
      });

      $o.hide();

    },

    render: function (list){
      $results = $('.team-select-search-results');
      $results.html('');

      var l = _.groupBy(list, 'group');

      _.each(l, function ( groupList, groupName ){
        $results.append('<h3>' + groupName + '<h3>')

        _.each(groupList, function (x){
          var html = '<li data-group-id="' + x.id + '">'
                   +   '<span class="team-name">' + x.name + '</span>'
                   +   '<span class="team-path">' + x.group + '</span>'
                   +   '<span class="team-path">' + x.path + '</span>'
                   + '</li>';
          $results.append($(html));
        });
      });
    }
  };

  return TeamAutocomplete;
})();

$(function (){
  $('select.select-autocomplete').each(function (i, o){
    TeamAutocomplete.enhance2(o);
  });
});
