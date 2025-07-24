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
end
