namespace :peoplefinder do

  def inadequate_profiles
    @inadequate_profiles = Person.inadequate_profiles
  end

  def inadequate_profiles_at_permitted_email_domain
    inadequate_profiles.select { |person| person.at_permitted_domain? }
  end

  desc 'list the email addresses of people with inadequate profiles'
  task inadequate_profiles: :environment do

    inadequate_profiles.each do |person|
      puts "#{ person.surname }, #{ person.given_name }: #{ person.email }"
    end
    puts "\n** There are #{ inadequate_profiles.count } inadequate profiles."
    puts "** #{ inadequate_profiles_at_permitted_email_domain.count }
      inadequate profiles have email addresses at permitted domains."
    puts "\n"
  end

  desc 'email people with inadequate profiles'
  task inadequate_profile_reminders: :environment do
    recipients = inadequate_profiles_at_permitted_email_domain

    puts "\nYou are about to email #{ recipients.count } people"
    puts 'Are you sure you want to do this? [Y/N]'

    if STDIN.gets.chomp == 'Y'
      recipients.each do |recipient|
        ReminderMailer.inadequate_profile(recipient).deliver_now
        puts "Email sent to: #{ recipient.email }"
      end
    end
  end
end
