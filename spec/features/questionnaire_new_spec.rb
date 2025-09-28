require "rails_helper"

RSpec.feature "Questionnaire (and it's child resources: question, submission, and submission_values)", :js do
  let(:questionnaire_prism) { QuestionnairePrism.new }
  let!(:owner) { create(:user) }
  let!(:questionnaire) { create(:questionnaire, user: owner) }

  before do
    sign_in(owner)
  end

  scenario "user can create, update, and move, and remove questions and it will appears on table as column" do
    create(:question, :number, name: "existing question", questionnaire: questionnaire, position: 1)
    create(:question, :number, name: "unnecessary question", questionnaire: questionnaire, position: 99)
    edit_questions_page = questionnaire_prism.edit_questions
    edit_questions_page.load(id: questionnaire.id)
    # remove unnecessary question (last) -> add new question2 -> add new question1 and move up two step
    # go back to question2 and move up a step -> rename the last question (which is the existing question)
    edit_questions_page.main_view.question_form_cards_wrapper.question_form_cards.last.remove_btn.click
    edit_questions_page.main_view.question_form_actionbar.add_question_btn.click
    edit_questions_page.main_view.question_form_cards_wrapper.question_form_cards.last.name_field.fill_in with: "question2"
    edit_questions_page.main_view.question_form_actionbar.add_question_btn.click
    edit_questions_page.main_view.question_form_cards_wrapper.question_form_cards.last.within do |form_card|
      form_card.name_field.fill_in with: "question1"
      form_card.move_up_btn.click
      form_card.move_up_btn.click
    end
    edit_questions_page.main_view.question_form_cards_wrapper.question_form_cards.last.within do |form_card|
      form_card.move_up_btn.click
    end
    edit_questions_page.main_view.question_form_cards_wrapper.question_form_cards.last.name_field.fill_in with: "existing question3"
    edit_questions_page.main_view.submit_btn.click

    main_page = questionnaire_prism.main
    expect(main_page).to be_displayed
    expect(main_page.main_view).to have_table
    expect(main_page.main_view.table.columns_text).to eq(["question1", "question2", "existing question3"])
    expect(main_page.main_view.table).to have_no_rows
    main_page.subnavbar.click_link_or_button("log new data")
    add_submission = questionnaire_prism.add_submission
    expect(add_submission).to be_displayed
    expect(add_submission.main_view).to have_question_fields(count: 3)
    expect(add_submission.question_labels_text).to eq(["question1 text required", "question2 text required", "existing question3 number required"])
  end

  scenario "user can create new submission and it appears on table as row" do
    random_date = -> { Faker::Date.between(from: 1.month.ago, to: Date.today) }
    questions = [
      create(:question, :text, name: "first question", questionnaire: questionnaire, position: 0, created_at: random_date),
      create(:question, :number, name: "amount", questionnaire: questionnaire, position: 1, created_at: random_date),
      create(:question, :text, name: "background", questionnaire: questionnaire, position: 1, created_at: random_date),
      create(:question, :number, name: "count", questionnaire: questionnaire, position: 1, created_at: random_date),
      create(:question, :text, name: "description", questionnaire: questionnaire, position: 1, created_at: random_date),
      create(:question, :number, name: "last question", questionnaire: questionnaire, position: 999, created_at: random_date)
    ]
    create(:question, :text, name: "non-existing-question", position: 1)

    add_submission_page = questionnaire_prism.add_submission
    add_submission_page.load(id: questionnaire.id)
    question_fields = add_submission_page.main_view.question_fields
    submission_values = ["text1", "1", "text2", "2", "text3", "3"]
    submission_values.each_with_index do |submission_value, i|
      question_fields[i].question_field.fill_in with: submission_value
    end
    add_submission_page.main_view.submit_btn.click
    main_page = questionnaire_prism.main
    expect(main_page).to be_displayed
    expect(main_page.main_view).to have_table
    expect(main_page.main_view.table.columns_text).to eq(questions.map(&:name))
    expect(main_page.main_view.table.rows_text.first).to start_with(submission_values)
  end

  scenario "user can update submission" do
    create(:question, :text, name: "first question", questionnaire: questionnaire, position: 0)
    create(:question, :number, name: "amount", questionnaire: questionnaire, position: 1)

    add_submission_page = questionnaire_prism.add_submission
    add_submission_page.load(id: questionnaire.id)
    question_fields = add_submission_page.main_view.question_fields
    submission_values = ["text1", "1"]
    submission_values.each_with_index do |submission_value, i|
      question_fields[i].question_field.fill_in with: submission_value
    end
    add_submission_page.main_view.submit_btn.click
    main_page = questionnaire_prism.main
    main_page.main_view.table.row_actions.first.click_link_or_button("edit")
    question_fields = add_submission_page.main_view.question_fields.first.question_field.fill_in with: "updated text"
    add_submission_page.main_view.submit_btn.click

    expect(main_page.main_view.table.rows_text.first).to start_with(["updated text", "1"])
  end

  scenario "user can remove submission" do
    create(:question, :text, name: "first question", questionnaire: questionnaire, position: 0)
    create(:question, :number, name: "amount", questionnaire: questionnaire, position: 1)

    add_submission_page = questionnaire_prism.add_submission
    add_submission_page.load(id: questionnaire.id)
    question_fields = add_submission_page.main_view.question_fields
    submission_values = ["text1", "1"]
    submission_values.each_with_index do |submission_value, i|
      question_fields[i].question_field.fill_in with: submission_value
    end
    add_submission_page.main_view.submit_btn.click
    main_page = questionnaire_prism.main
    main_page.main_view.table.row_actions.first.click_link_or_button("remove")

    expect(main_page.main_view.table).to have_no_rows
  end
end
