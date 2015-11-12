class SuggestionMailerPreview < ActionMailer::Preview

  def person_email
    SuggestionMailer.person_email(person, suggester, suggestion)
  end

  def team_admin_email
    SuggestionMailer.team_admin_email(person, suggester, suggestion, FactoryGirl.build(:super_admin))
  end

  private
    def person
      Person.take
    end
    alias_method :suggester, :person

    def suggestion
      Person.take
    end

    def suggestion
      {
        duplicate_profile: true,
        incorrect_location_of_work: true,
        incorrect_image: true,
        missing_fields_info: 'Date of Birth, Bank account details'
      }
    end

end
