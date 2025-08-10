require "rails_helper"

RSpec.feature "Questions", :js do
  it "user can submit a new submission on a questionnaire with question sorted by position and name (asc)" do
    user = create(:user)
    questionnaire = create(:questionnaire, user: user)

    questions = [
      create(:question, questionnaire: questionnaire, position: 0),
      create(:question, :text, name: "name", questionnaire: questionnaire, position: 12),
      create(:question, :number, name: "naps amount", questionnaire: questionnaire, position: 12),
      create(:question, :number, name: "naps count", questionnaire: questionnaire, position: 12),
      create(:question, :number, name: "rating", questionnaire: questionnaire, position: 999)
    ]

    submission_values = questions.map do |question|
      build(:submission_value, question: question)
    end

    nonexisting_question = create(:question)

    sign_in(user)

    visit questionnaire_path(questionnaire)

    first("button, a", text: "log new data").click

    expect(page).to have_current_path(new_questionnaire_submission_path(questionnaire))

    expect(page).to have_content(questionnaire.title)
    expect(page).to have_content(questionnaire.description)

    within("form[action='#{questionnaire_submissions_path(questionnaire)}']") do
      all(:fillable_field, name: /submission_value/).zip(submission_values).each do |field, submission_value|
        field.fill_in with: submission_value.value
      end

      find("[type='submit']").click
    end

    expect(page).to have_current_path(questionnaire_path(questionnaire))
    expect(page).to have_content(questionnaire.title)
    expect(page).to have_table(with_rows: [
      questions.zip(submission_values).to_h { |pair| [pair.first.name, pair.second.value] }
    ])
    expect(page).not_to have_content(nonexisting_question.name)
  end

  it "show validation error and prevent submit on submission form" do
    user = create(:user)
    questionnaire = create(:questionnaire, user: user)

    questions = [
      create(:question, :number, name: "a number field", questionnaire: questionnaire),
      create(:question, :text, name: "non emptyable field", questionnaire: questionnaire),
      create(:question, :text, name: "field that user answer correctly", questionnaire: questionnaire)
    ]

    submission_values = [
      build(:submission_value, value: "asjdflaksjf", question: questions[0]),
      build(:submission_value, value: "", question: questions[1]),
      build(:submission_value, value: "a correct answer", question: questions[2])
    ]

    sign_in(user)

    visit questionnaire_path(questionnaire)

    first("button, a", text: "log new data").click

    expect(page).to have_current_path(new_questionnaire_submission_path(questionnaire))

    expect(page).to have_content(questionnaire.title)
    expect(page).to have_content(questionnaire.description)

    within("form[action='#{questionnaire_submissions_path(questionnaire)}']") do
      all(:fillable_field, name: /submission_value/).zip(submission_values).each do |field, submission_value|
        field.fill_in with: submission_value.value
      end

      find("[type='submit']").click
    end

    expect(page).to have_current_path(new_questionnaire_submission_path(questionnaire))
    expect(page).to have_content(questionnaire.title)
    expect(page).to have_content("can't be blank")
    expect(page).to have_content("not a number")
  end

  it "user can edit submitted record" do
    user = create(:user)
    questionnaire = create(:questionnaire, user: user)

    question1 = create(:question, :text, name: "name", questionnaire: questionnaire, position: 1)
    question2 = create(:question, :number, name: "count", questionnaire: questionnaire, position: 2)

    submission1 = create(:submission, questionnaire: questionnaire) do |submission|
      create(:submission_value, questionnaire: questionnaire, question: question1, submission: submission)
      create(:submission_value, questionnaire: questionnaire, question: question2, submission: submission)
    end

    create(:submission, questionnaire: questionnaire) do |submission|
      create(:submission_value, questionnaire: questionnaire, question: question1, submission: submission)
      create(:submission_value, questionnaire: questionnaire, question: question2, submission: submission)
    end

    new_text_submission_value = build(:submission_value, value: "new updated value")
    new_number_submission_value = build(:submission_value, value: "1234567890")

    sign_in(user)

    visit questionnaire_path(questionnaire)

    find(:table_row, {question1.name => submission1.submission_values.first.value}).find("button, a", text: "edit").click

    expect(page).to have_current_path(edit_questionnaire_submission_path(questionnaire, submission1))
    expect(page).to have_link(href: questionnaire_path(questionnaire))

    within(:element, "form", action: questionnaire_submission_path(questionnaire, submission1)) do
      find(:fillable_field, with: submission1.submission_values.first.value).fill_in with: new_text_submission_value.value
      find(:fillable_field, with: submission1.submission_values.last.value).fill_in with: new_number_submission_value.value

      find("[type='submit']").click
    end

    expect(page).to have_current_path(questionnaire_path(questionnaire))
    expect(page).to have_content(questionnaire.title)
    expect(page).to have_table(with_rows: [
      [question1, question2].zip(submission1.submission_values).to_h { |pair| [pair.first.name, pair.second.value] }
    ])

    expect(page).to have_selector("tbody > tr", count: 2)
  end

  it "user can remove submitted submission" do
    user = create(:user)
    questionnaire = create(:questionnaire, user: user)

    question1 = create(:question, :text, name: "name", questionnaire: questionnaire, position: 1)
    question2 = create(:question, :number, name: "count", questionnaire: questionnaire, position: 2)

    deleted_submission = create(:submission, questionnaire: questionnaire) do |submission|
      create(:submission_value, questionnaire: questionnaire, question: question1, submission: submission)
      create(:submission_value, questionnaire: questionnaire, question: question2, submission: submission)
    end
    deleted_submission_values = deleted_submission.submission_values.map(&:value)

    submission2 = create(:submission, questionnaire: questionnaire) do |submission|
      create(:submission_value, questionnaire: questionnaire, question: question1, submission: submission)
      create(:submission_value, questionnaire: questionnaire, question: question2, submission: submission)
    end

    sign_in(user)

    visit questionnaire_path(questionnaire)

    accept_prompt do
      find(:table_row, {question1.name => deleted_submission.submission_values.first.value}).find("button, a", text: "remove").click
    end

    expect(page).to have_current_path(questionnaire_path(questionnaire))
    expect(page).to have_table(with_rows: [
      [question1, question2].zip(submission2.submission_values).to_h { |pair| [pair.first.name, pair.second.value] }
    ])
    expect(page).not_to have_table(with_rows: [
      [question1, question2].zip(deleted_submission_values).to_h { |pair| [pair.first.name, pair.second] }
    ])
    expect(page).to have_selector("tbody > tr", count: 1)
  end
end
