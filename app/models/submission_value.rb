class SubmissionValue < ApplicationRecord
  belongs_to :questionnaire
  belongs_to :submission
  belongs_to :question

  validates :value, presence: {unless: :is_emptyable?}
  validates :value, numericality: true, if: :number?

  after_initialize :set_questionnaire_defaults

  def set_questionnaire_defaults
    if new_record?
      derive_questionnaire_id = submission&.questionnaire_id || question&.questionnaire_id
      self.questionnaire_id ||= derive_questionnaire_id
    end
  end

  def number?
    question.number?
  end

  def is_emptyable?
    question.is_emptyable?
  end
end
