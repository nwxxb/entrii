require "rails_helper"

RSpec.describe Question, type: :model do
  it "validates name (presence, length: 0..50, doesn't contain newline)" do
    invalid_questions = [
      build(:question, name: "title " * 10),
      build(:question, name: "title\ntitle"),
      build(:question, name: "")
    ]
    valid_questions = [
      build(:question, name: "title"),
      build(:question, name: "title (valid & good)"),
      build(:question, name: "valid_title"),
      build(:question, name: "valid-title")
    ]

    invalid_questions.each(&:valid?)
    valid_questions.each(&:valid?)

    expect(invalid_questions.map { |f| f.errors.attribute_names }).to all(eq([:name]))
    expect(valid_questions.map { |f| f.errors.attribute_names }).to all(eq([]))
  end

  it "validates description (length: 0..280)" do
    invalid_questions = [
      build(:question, description: "title " * 56)
    ]

    valid_questions = [
      build(:question, description: "description"),
      build(:question, description: "valid\ndescription"),
      build(:question, description: "")
    ]

    invalid_questions.each(&:valid?)
    valid_questions.each(&:valid?)

    expect(invalid_questions.map { |f| f.errors.attribute_names }).to all(eq([:description]))
    expect(valid_questions.map { |f| f.errors.attribute_names }).to all(eq([]))
  end

  it "validates value_type (presence, comply with defined enum)" do
    invalid_questions = [
      build(:question, value_type: ""),
      build(:question, value_type: nil)
    ]

    valid_questions = [
      build(:question, value_type: "text"),
      build(:question, value_type: "number")
    ]

    invalid_questions.each(&:valid?)
    valid_questions.each(&:valid?)

    expect(invalid_questions.map { |f| f.errors.attribute_names }).to all(eq([:value_type]))
    expect(valid_questions.map { |f| f.errors.attribute_names }).to all(eq([]))
    expect { build(:question, value_type: "adlfjasdf") }.to raise_error(ArgumentError)
  end
end
