require "rails_helper"

RSpec.describe Questionnaire, type: :model do
  it "validates title (presence, length: 0..100, doesn't contain newline)" do
    invalid_questionnaires = [
      build(:questionnaire, title: "title " * 20),
      build(:questionnaire, title: "title\ntitle"),
      build(:questionnaire, title: "")
    ]
    valid_questionnaires = [
      build(:questionnaire, title: "title"),
      build(:questionnaire, title: "title (valid & good)"),
      build(:questionnaire, title: "valid_title"),
      build(:questionnaire, title: "valid-title")
    ]

    invalid_questionnaires.each(&:valid?)
    valid_questionnaires.each(&:valid?)

    expect(invalid_questionnaires.map { |f| f.errors.attribute_names }).to all(eq([:title]))
    expect(valid_questionnaires.map { |f| f.errors.attribute_names }).to all(eq([]))
  end

  it "validates description (length: 0..280)" do
    invalid_questionnaires = [
      build(:questionnaire, description: "title " * 56)
    ]

    valid_questionnaires = [
      build(:questionnaire, description: "description"),
      build(:questionnaire, description: "valid\ndescription"),
      build(:questionnaire, description: "")
    ]

    invalid_questionnaires.each(&:valid?)
    valid_questionnaires.each(&:valid?)

    expect(invalid_questionnaires.map { |f| f.errors.attribute_names }).to all(eq([:description]))
    expect(valid_questionnaires.map { |f| f.errors.attribute_names }).to all(eq([]))
  end

  it "can create, update, and delete, and soft delete questions" do
    questionnaire = create(:questionnaire)

    existing_question_1 = create(:question, questionnaire: questionnaire)
    existing_question_2 = create(:question, questionnaire: questionnaire)
    discarded_question_1 = create(:question, questionnaire: questionnaire) do |q|
      create(:submission_value, question: q, questionnaire: questionnaire)
    end
    removed_question_2 = create(:question, questionnaire: questionnaire)

    questions_attributes = {
      questions_attributes: {
        "1324712947103284" => {name: "a question"},
        "0" => {name: "a question", _destroy: "0"},
        "010231" => {name: "a question", _destroy: "1"},
        "101001" => {id: existing_question_1.id.to_s, name: "updated_name_for_question_1"},
        existing_question_2.id.to_s => {id: existing_question_2.id.to_s, name: "updated_name_for_question_2"},
        "123792111" => {id: discarded_question_1.id.to_s, _destroy: "1"},
        removed_question_2.id.to_s => {id: removed_question_2.id.to_s, _destroy: "1"}
      }.each_value do |val| # temporarily use 0 as default position value
        val[:position] = 0
      end
    }

    questionnaire.update(questions_attributes)

    expect(questionnaire.questions.all.length).to eq(5)
    expect(questionnaire.questions.kept.length).to eq(4)
    expect(questionnaire.questions.discarded.length).to eq(1)
  end

  it "questions getter automatically order by it's position" do
    questionnaire = create(:questionnaire)

    existing_questions_1 = create(:question, questionnaire: questionnaire, position: 1)
    existing_questions_4 = create(:question, questionnaire: questionnaire, position: 99999)
    existing_questions_3 = create(:question, questionnaire: questionnaire, position: 999)
    existing_questions_2 = create(:question, questionnaire: questionnaire, position: 200)

    questions_names = questionnaire.questions.map(&:name)

    expect(questions_names).to match([
      existing_questions_1.name,
      existing_questions_2.name,
      existing_questions_3.name,
      existing_questions_4.name
    ])
  end
end
