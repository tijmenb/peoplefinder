class UserUpdateMailerPreview < ActionMailer::Preview

  def new_profile_email
    UserUpdateMailer.new_profile_email(person, by_email)
  end

  def updated_profile_email
    UserUpdateMailer.updated_profile_email(person, by_email)
  end

  def deleted_profile_email
    UserUpdateMailer.deleted_profile_email(person.email, person.given_name, by_email)
  end

private
  def person
    @_person ||= Person.take
  end

  def by_email
    'test@example.com'
  end
end
