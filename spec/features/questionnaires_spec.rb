require "rails_helper"

RSpec.feature "Questionnaires", :js do
  it "user need to login to access lists of questionnaires" do
    visit questionnaires_path

    expect(page).to have_current_path(new_user_session_path)
  end

  it "questionnaires menu exist in signed in user's navbar" do
    user = create(:user)
    sign_in(user)

    visit root_path

    expect(page).to have_link("questionnaires", href: questionnaires_path)
  end

  it "logged in user can list all created questionnaires" do
    user = create(:user)
    questionnaire1 = create(:questionnaire, title: "questionnaire 1", user: user)
    questionnaire2 = create(:questionnaire, title: "questionnaire 2")
    questionnaire3 = create(:questionnaire, title: "questionnaire 3", user: user)

    sign_in(user)

    visit questionnaires_path

    expect(page).to have_content("Questionnaires")
    expect(page).to have_link("questionnaire 1", href: questionnaire_path(questionnaire1))
    expect(page).not_to have_link("questionnaire 2", href: questionnaire_path(questionnaire2))
    expect(page).to have_link("questionnaire 3", href: questionnaire_path(questionnaire3))
  end

  it "user can create new questionnaire" do
    user = create(:user)
    questionnaire = build(:questionnaire)

    sign_in(user)

    visit questionnaires_path

    first("button, a", text: "new questionnaire").click

    expect(page).to have_current_path(new_questionnaire_path)

    within("form[action='#{questionnaires_path}']") do
      fill_in "questionnaire_title", with: questionnaire.title
      fill_in "questionnaire_description", with: questionnaire.description

      find("[type='submit']").click
    end

    expect(page).to have_current_path(Regexp.new(questionnaires_path + '\/' + '\d+'))
    expect(page).to have_content(questionnaire.title)
  end

  # create questions/generate question from csv happen in the show details
  # see spec/features/questionnaire_spec.rb
  # xit "user can list create new questionnaire and generate the question" do
  # end

  it "user create invalid questionnaire" do
    user = create(:user)

    sign_in(user)
    visit new_questionnaire_path
    within("form[action='#{questionnaires_path}']") do
      fill_in "questionnaire_title", with: ""

      find("[type='submit']").click
    end

    expect(page).to have_current_path(new_questionnaire_path)
    expect(page).to have_selector("#error_explanation")
  end

  it "user need to login to access a questionnaire detail" do
    owner = create(:user)
    invalid_user = create(:user)
    questionnaire = create(:questionnaire, user: owner)

    sign_in(invalid_user)
    rails_responds_without_detailed_exceptions do
      visit questionnaire_path(questionnaire)
    end

    expect(page.status_code).to eq(404)
    expect(page).to have_content("404")
  end
end
