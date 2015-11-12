class GroupUpdateMailer < ApplicationMailer

  def inform_subscriber(recipient, group, person_responsible)
    @group = group
    @recipient = recipient
    @person_responsible = person_responsible
    @group_url = group_url(group)

    mail to: recipient.email
  end
end
