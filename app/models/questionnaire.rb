class Questionnaire < ApplicationRecord
  belongs_to :user

  validates :title,
    presence: true,
    length: {in: 1..100},
    format: {
      with: /\A[\w\ \&\(\)\-]+\z/,
      message: "can only contain alphabet, number, parentheses,and &-_"
    }

  validates :description, length: {in: 0..280}

  has_many :questions
  accepts_nested_attributes_for :questions, allow_destroy: true
end
