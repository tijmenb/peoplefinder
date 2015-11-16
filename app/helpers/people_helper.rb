module PeopleHelper
  def day_name(symbol)
    I18n.t(symbol, scope: [:people, :day_names])
  end

  def day_symbol(symbol)
    I18n.t(symbol, scope: [:people, :day_symbols])
  end

  def profile_image_tag(person, options = {})
    content_tag(:div, class: 'maginot') {
      image_tag(person.profile_image_source, options.merge(alt: "Current photo of #{ person }")) +
      content_tag(:div, class: 'barrier') {}
    }
  end

  # Why do we need to go to this trouble to repeat new_person/edit_person? you
  # might wonder. Well, form_for only allows us to replace the form class, not
  # augment it, and we rely on the default classes elsewhere.
  #
  def person_form_class(person, activity)
    [person.new_record? ? 'new_person' : 'edit_person'].tap { |classes|
      classes << 'completing' if activity == 'complete'
    }.join(' ')
  end

  def cities_options(person)
    cities = City.by_name.map{|city| [city.name, city.id]}
    options_for_select [["- select city -",""]] + cities, person.city_id
  end

  def buildings_options(person)
    buildings = Building.by_name.map{|building| [building.address, building.id]}
    options_for_select [["- select building -",""]] + buildings, person.building_id
  end
end
