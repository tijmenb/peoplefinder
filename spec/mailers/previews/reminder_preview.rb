class ReminderMailerPreview < ActionMailer::Preview

  def inadequate_profile
    person = Person.first
    ReminderMailer.inadequate_profile(person)
  end
end
