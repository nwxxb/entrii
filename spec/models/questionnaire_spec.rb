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
end
