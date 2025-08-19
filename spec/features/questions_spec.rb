require "rails_helper"

RSpec.feature "Questions", :js do
  it "user can create, edit, and remove both existing and new questions" do
    user = create(:user)
    questionnaire = create(:questionnaire, user: user)
    existing_questions = [
      create(:question, name: "existing_question_1", questionnaire: questionnaire),
      create(:question, name: "existing_question_2", questionnaire: questionnaire),
      create(:question, name: "existing_question_3", questionnaire: questionnaire)
    ]
    removed_questions = [
      create(:question, name: "destroyed_question_1", questionnaire: questionnaire)
    ]
    new_questions = [
      build(:question, name: "new_question_1"),
      build(:question, name: "new_question_2"),
      build(:question, name: "new_question_3")
    ]
    deferred_questions = [
      build(:question, name: "deferred_question_1"),
      build(:question, name: "deferred_question_2"),
      build(:question, name: "deferred_question_3")
    ]

    sign_in(user)

    visit questionnaire_path(questionnaire)

    first("button, a", text: "edit structure").click

    expect(page).to have_current_path(edit_questionnaire_questions_path(questionnaire))

    expect(page).to have_content(questionnaire.title)
    expect(page).to have_content(questionnaire.description)

    within("form[action='#{questionnaire_questions_path(questionnaire)}']") do
      existing_questions.each.with_index do |existing_question, index|
        question_form = find("input[name*='[id]'][value='#{existing_question.id}']", visible: :hidden).ancestor("div.question-form")
        question_form.find("input[name^='questionnaire[questions_attributes]'][name$='[name]']").fill_in with: existing_question.name + "_updated"
        question_form.find("input[name^='questionnaire[questions_attributes]'][name$='[description]']").fill_in with: existing_question.description
        question_form.find("select[name^='questionnaire[questions_attributes]'][name$='[value_type]']").select existing_question.value_type
        question_form.find("label[for^='questionnaire_questions_attributes'][for$='_is_emptyable']").click
      end

      new_questions.each do |new_question|
        find("button, a", text: "add question").click

        all("input[name^='questionnaire[questions_attributes]'][name$='[name]']").last.fill_in with: new_question.name
        all("input[name^='questionnaire[questions_attributes]'][name$='[description]']").last.fill_in with: new_question.description
        all("select[name^='questionnaire[questions_attributes]'][name$='[value_type]']").last.select new_question.value_type
        all("label[for^='questionnaire_questions_attributes'][for$='is_emptyable']").last.click
      end

      removed_questions.each do |removed_question|
        find("input[id$='_id'][value='#{removed_question.id}']", visible: :hidden)
          .ancestor(".card.question-form").find("button[data-behaviour='remove-question-form'").click

        expect(page).not_to have_css("input[value='#{removed_question.name}']")
      end

      deferred_questions.each do |deferred_question|
        find("button, a", text: "add question").click

        all("input[name^='questionnaire[questions_attributes]'][name$='[name]']").last.fill_in with: deferred_question.name
        all("input[name^='questionnaire[questions_attributes]'][name$='[description]']").last.fill_in with: deferred_question.description
        all("select[name^='questionnaire[questions_attributes]'][name$='[value_type]']").last.select deferred_question.value_type
        all("label[for^='questionnaire_questions_attributes'][for$='is_emptyable']").last.click

        all("button[data-behaviour='remove-question-form'").last.click
        expect(page).not_to have_css("input[value='#{deferred_question.name}']")
      end

      find("[type='submit']").click
    end

    expect(page).to have_current_path(questionnaire_path(questionnaire))
    expect(page).to have_content(questionnaire.title)

    existing_questions.each do |existing_question|
      expect(page).not_to have_content(existing_question.name, exact: true)
      expect(page).to have_content(existing_question.name + "_updated")
    end

    removed_questions.each do |removed_question|
      expect(page).not_to have_content(removed_question.name)
    end

    new_questions.each do |new_question|
      expect(page).to have_content(new_question.name)
    end

    deferred_questions.each do |deferred_question|
      expect(page).not_to have_content(deferred_question.name)
    end
  end

  it "user can change the positions of all questions" do
    user = create(:user)
    questionnaire = create(:questionnaire, user: user)
    existing_questions1 = create(:question, questionnaire: questionnaire, position: 0)
    existing_questions2 = create(:question, questionnaire: questionnaire, position: 1)
    existing_questions3 = create(:question, questionnaire: questionnaire, position: 3)
    new_question1 = build(:question)

    sign_in(user)

    visit questionnaire_path(questionnaire)

    first("button, a", text: "edit structure").click

    expect(page).to have_content(questionnaire.title)
    expect(page).to have_content(questionnaire.description)

    within("form[action='#{questionnaire_questions_path(questionnaire)}']") do
      find("button, a", text: "add question").click

      all("input[name^='questionnaire[questions_attributes]'][name$='[name]']").last.fill_in with: new_question1.name
      all("button, a", text: "move up").last.click

      find("input[id$='_id'][value='#{existing_questions1.id}']", visible: :hidden)
        .ancestor(".card.question-form").find("button, a", text: "move down").click

      find("[type='submit']").click
    end

    expect(page).to have_current_path(questionnaire_path(questionnaire))
    expect(page).to have_content(questionnaire.title)
    texts = all("th").map(&:text)
    expect(texts).to eq([
      existing_questions2.name,
      existing_questions1.name,
      new_question1.name,
      existing_questions3.name
    ])
    expect(page).to have_table(rows: [])
  end

  xit "user can upload a csv to generate the questionnaire structure"
end
