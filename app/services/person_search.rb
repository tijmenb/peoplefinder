class PersonSearch
  def fuzzy_search(text, max = 100)
    Person.search(
      size: max,
      query: search_query(text)
    ).records.limit(max)
  end

  private
    def search_query(text)
      if text.present?
        {
          fuzzy_like_this: {
            fields: [
              :name, :tags, :description, :location_in_building, :building_value,
              :city_value, :role_and_group, :community_name, :staff_nr,
            ],
            like_text: text, prefix_length: 3, ignore_tf: true
          }
        }
      else
        {match_all: {}}
      end
    end

end
