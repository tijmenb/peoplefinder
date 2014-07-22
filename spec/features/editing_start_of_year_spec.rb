require 'rails_helper'

feature "Editing start of year agreement" do
  before do
    password = generate(:password)
    jobholder = create(:user, name: 'John Doe', password: password)
    create(:agreement, jobholder: jobholder)
    log_in_as jobholder.email, password
  end

  scenario "Edititing responsibilities as a jobholder" do
    click_button "Continue"
    within('h1') do
      expect(page.text).to have_text("John Doe’s responsibilities")
    end

    fill_in "Number of staff", with: "There's about 300"
    fill_in "Staff engagement score", with: "I did pretty well for a while"

    within ('#budgetary-responsibilities') do
      fill_in "Type", with: "Capital"
      fill_in "Value", with: "200 quid"
      fill_in "Description", with: "Paid annually"
    end

    within ('#objectives') do
      fill_in "Type", with: "Productivity goal"
      fill_in "Objective", with: "Get to work on time"
      fill_in "Deliverable", with: "A copy of my timesheet"
      fill_in "Measures / Target", with: "An average tardiness of 2.7 minutes"
    end

    click_button "Save"

    agreement = Agreement.last
    budgetary_responsibility = agreement.budgetary_responsibilities.first
    objectives = agreement.objectives.first

    expect(agreement.number_of_staff).to match(/about 300/)
    expect(agreement.staff_engagement_score).to match(/did pretty well/)

    expect(budgetary_responsibility['budget_type']).to match(/Capital/)
    expect(budgetary_responsibility['budget_value']).to match(/200 quid/)
    expect(budgetary_responsibility['description']).to match(/annually/)

    expect(objectives['objective_type']).to match(/Productivity goal/)
    expect(objectives['description']).to match(/Get to work/)
    expect(objectives['deliverable']).to match(/copy of my timesheet/)
    expect(objectives['measures']).to match(/average tardiness/)
  end

  scenario 'Add and remove budgetary responsibilities to an agreement', js: true do
    click_button "Continue"

    within('#budgetary-responsibilities') do
      expect(page).not_to have_link('Remove last row')

      2.times do
        click_link "Add another"
      end
      expect(page).to have_css('.budgetary-responsibility', count: 3)

      click_link "Remove last row"
      expect(page).to have_css('.budgetary-responsibility', count: 2)

      click_link "Remove last row"
      expect(page).to have_css('.budgetary-responsibility', count: 1)
      expect(page).not_to have_link('Remove last row')
    end
  end
end
