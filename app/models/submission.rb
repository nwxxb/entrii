class Submission < ApplicationRecord
  belongs_to :questionnaire
  has_many :submission_values, dependent: :destroy
  accepts_nested_attributes_for :submission_values, allow_destroy: true

  def whole_submission_values
    existing_submission_values = submission_values.index_by { |sv| [sv.submission_id, sv.question_id] }

    result = []
    questionnaire.questions.kept.each do |q|
      key = [id, q.id]

      result << (existing_submission_values[key] || SubmissionValue.new(
        questionnaire: questionnaire,
        submission: self,
        question: q
      ))
    end

    result
  end
end
