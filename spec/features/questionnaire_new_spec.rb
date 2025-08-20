require "rails_helper"

RSpec.feature "Questionnaire (and it's child resources: question, submission, and submission_values)", :js do
  let(:owner) { create(:user) }
  let(:questionnaire) { create(:questionnaire, user: owner) }
  let(:question1) { create(:question, :text, questionnaire: questionnaire) }
  let(:question2) { create(:question, :number, questionnaire: questionnaire) }

  let(:submission1) do
    create(:submission, questionnaire: questionnaire) do |s|
      create(:submission_value, questionnaire: questionnaire, question: question1, submission: s)
      create(:submission_value, questionnaire: questionnaire, question: question2, submission: s)
    end
  end

  let(:submission2) do
    create(:submission, questionnaire: questionnaire) do |s|
      create(:submission_value, questionnaire: questionnaire, question: question1, submission: s)
      create(:submission_value, questionnaire: questionnaire, question: question2, submission: s)
    end
  end

  context "when questionnaire is empty" do
    before do
      owner
      questionnaire
    end

    context "when visiting main show view" do
      before do
        sign_in(owner)
        visit questionnaire_path(questionnaire)
      end

      it "user can see title and description of questionnaire" do
        expect(page).to have_content(questionnaire.title)
        expect(page).to have_content(questionnaire.description)
      end

      it "user see empty table" do
        expect(page).not_to have_table
      end

      it "user see button to upload csv or edit structure" do
        expect(page).to have_content("no question found")
        expect(page).to have_link("initiate structure", href: edit_questionnaire_questions_path(questionnaire))
      end

      it "add log/submission button/link is disabled" do
        expect(page).to have_selector(:button, "log new data", disabled: true)
      end
    end

    context "when editing structure/questions" do
      before do
        sign_in(owner)
        visit edit_questionnaire_questions_path(questionnaire)
      end

      it "show upload csv button (and disappear when new fieldset exist)" do
        expect(page).to have_selector("[data-target='empty-state-ghost-section']")
        find(:button, "add question").click
        expect(page).not_to have_selector("[data-target='empty-state-ghost-section']")
      end

      it "disabled preview button" do
        expect(page).to have_button("preview", disabled: true)
      end
    end

    context "when logging new data" do
      before do
        sign_in(owner)
        visit new_questionnaire_submission_path(questionnaire)
      end

      it "forbid user and alert that questions don't exist" do
        expect(page).to have_content("current questionnaire doesn't have any questions yet")
        expect(page).to have_current_path(questionnaire_path(questionnaire))
      end
    end
  end
end
