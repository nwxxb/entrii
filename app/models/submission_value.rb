class SubmissionValue < ApplicationRecord
  belongs_to :submission
  belongs_to :question

  validates :value, presence: {unless: :is_emptyable?}
  validates :value, numericality: true, if: :number?

  def number?
    question.number?
  end

  def is_emptyable?
    question.is_emptyable?
  end
end
