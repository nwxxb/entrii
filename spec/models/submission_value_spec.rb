require "rails_helper"

RSpec.describe SubmissionValue, type: :model do
  describe "(DB constraint)" do
    it "errors if more than one submission_values with same question on a submission" do
      questionnaire = create(:questionnaire)
      question = create(:question, questionnaire: questionnaire)
      submission = create(:submission, questionnaire: questionnaire)
      _existing_submission_value = create(:submission_value, questionnaire: questionnaire, submission: submission, question: question)

      create_value_on_filled_question = lambda { create(:submission_value, questionnaire: questionnaire, question: question, submission: submission) }
      create_value_on_question_on_another_submission = lambda { create(:submission_value, questionnaire: questionnaire, question: question) }

      expect { create_value_on_filled_question.call }.to raise_error ActiveRecord::RecordNotUnique
      expect { create_value_on_question_on_another_submission.call }.not_to raise_error
    end

    it "errors on attaching submission_values to question that submission don't own" do
      questionnaire1 = create(:questionnaire)
      questionnaire2 = create(:questionnaire)
      questionnaire1_question = create(:question, questionnaire: questionnaire1)
      questionnaire2_question = create(:question, questionnaire: questionnaire2)

      questionnaire1_submission = create(:submission, questionnaire: questionnaire1)
      create_value_on_another_questionnaire_question = lambda do
        create(:submission_value, questionnaire: questionnaire1, submission: questionnaire1_submission, question: questionnaire2_question)
      end
      create_value_on_same_questionnaire_question = lambda do
        create(:submission_value, questionnaire: questionnaire1, submission: questionnaire1_submission, question: questionnaire1_question)
      end

      expect { create_value_on_another_questionnaire_question.call }.to raise_error ActiveRecord::ActiveRecordError
      expect { create_value_on_same_questionnaire_question.call }.not_to raise_error
    end
  end
end
