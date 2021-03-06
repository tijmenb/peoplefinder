require 'rails_helper'

feature 'Login page' do
  include PermittedDomainHelper

  let(:login_page) { Pages::Login.new }
  let(:token_created_page) { Pages::TokenCreated.new }

  context 'User from outside the network' do
    scenario 'Is presented with standard login page and copy' do
      visit '/'

      expect(login_page).to be_displayed
      expect(login_page.description).to have_text("If you don't have a government Google account, we can email you a secure link so you can log in to People Finder. The link will be active for 4 hours.")
    end
  end
  context 'User from inside the network' do
    before do
      page.driver.browser.header('RO', 'ENABLED')
    end

    scenario 'Is presented with standard login page and copy if they decide to login' do
      visit '/sessions/new'

      expect(login_page).to be_displayed
      expect(login_page.description).to have_text("If you don't have a government Google account, we can email you a secure link so you can log in to People Finder. The link will be active for 4 hours.")
    end

    scenario 'Is presented with special login page and copy if they are forced to login to make changes' do
      person = create(:person)

      visit person_path(person)
      click_link 'Edit this profile'

      expect(login_page).to be_displayed
      expect(login_page.description).to have_text('For security reasons, you have to be logged in to People Finder to make any changes.')
      expect(login_page.description).to have_text('We will email you a secure link so you can log in.')

      login_page.email.set(person.email)
      login_page.request_button.click

      expect(token_created_page).to be_displayed
      expect(token_created_page.info).to have_text('We’re just emailing you a link to access People Finder. This can take up to 5 minutes. When it arrives, click on the link (which is active for 4 hours).')
    end
  end
end
