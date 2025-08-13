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

  describe "#whole_submission_values" do
    it "return the whole submission_values with same amount and order of question positions" do
      submission = create(:submission)
      questionnaire = submission.questionnaire

      question2 = create(:question, name: "question2", questionnaire: questionnaire, position: 1)
      question1 = create(:question, name: "question1", questionnaire: questionnaire, position: 0)
      question4 = create(:question, name: "question4", questionnaire: questionnaire, position: 3)
      question3 = create(:question, name: "question3", questionnaire: questionnaire, position: 2)

      _submission_value2 = create(:submission_value, question: question2, submission: submission, questionnaire: questionnaire)
      _submission_value4 = create(:submission_value, question: question4, submission: submission, questionnaire: questionnaire)

      result = submission.whole_submission_values

      expect(result.length).to eq(4)
      expect(result.map(&:persisted?)).to eq([false, true, false, true])
      expect(result.map(&:question_id)).to eq([question1.id, question2.id, question3.id, question4.id])
    end
  end
end
