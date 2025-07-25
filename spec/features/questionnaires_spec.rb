require "rails_helper"

RSpec.feature "Questionnaires", :js do
  it "user need to login to access questionnaires spec" do
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

  it "user can list create new questionnaire" do
    user = create(:user)
    questionnaire = build(:questionnaire)
    questions = []

    sign_in(user)

    visit questionnaires_path

    find("button, a", text: "create questionnaire").click

    expect(page).to have_current_path(new_questionnaire_path)

    within("form[action='#{questionnaires_path}']") do
      fill_in "questionnaire_title", with: questionnaire.title
      fill_in "questionnaire_description", with: questionnaire.description

      3.times do |i|
        question = build(:question)
        find("button, a", text: "add question").click

        all("input[name^='questionnaire[questions_attributes]'][name$='[name]']").last.fill_in with: question.name
        all("textarea[name^='questionnaire[questions_attributes]'][name$='[description]']").last.fill_in with: question.description
        all("select[name^='questionnaire[questions_attributes]'][name$='[value_type]']").last.select question.value_type
        all("label[for^='questionnaire_questions_attributes'][for$='is_emptyable']").last.click

        questions << question
      end

      find("[type='submit']").click
    end

    expect(page).to have_current_path(Regexp.new(questionnaires_path + '\/' + '\d+'))
    expect(page).to have_content(questionnaire.title)
    questions.each do |question|
      expect(page).to have_content(question.name)
    end
  end

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
end
