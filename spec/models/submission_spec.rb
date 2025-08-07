require "rails_helper"

RSpec.describe Submission, type: :model do
  it "validate the submission if it's question is non-emptyable" do
    submission = create(:submission)
    question = create(:question, is_emptyable: false)
    value = ""

    status = submission.update(submission_values_attributes: {"9872198472143" => {question_id: question.id, value: value}})

    expect(status).to be(false)
    expect(submission.errors.attribute_names).to eq([:"submission_values.value"])
    expect(submission.errors.full_messages.join).to include("can't be blank")
  end

  it "only accept number if the question value type is number" do
    submission = create(:submission)
    question = create(:question, :number)
    value = "ajdslfkjsadlfkjsafd"

    status = submission.update(submission_values_attributes: {"9872198472143" => {question_id: question.id, value: value}})

    expect(status).to be(false)
    expect(submission.errors.attribute_names).to eq([:"submission_values.value"])
    expect(submission.errors.full_messages.join).to include("not a number")
  end
end
