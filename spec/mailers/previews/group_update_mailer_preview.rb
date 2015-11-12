class GroupUpdateMailerPreview < ActionMailer::Preview

  def inform_subscriber
    recipient = Person.take
    group     = Group.take
    person_responsible = FactoryGirl.build(:person)

    GroupUpdateMailer.inform_subscriber(recipient, group, person_responsible)
  end
end
