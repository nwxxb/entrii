class Submission < ApplicationRecord
  belongs_to :questionnaire
  has_many :submission_values
  accepts_nested_attributes_for :submission_values, allow_destroy: true
end
