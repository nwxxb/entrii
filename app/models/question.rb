class Question < ApplicationRecord
  belongs_to :questionnaire

  validates :name,
    presence: true,
    length: {in: 1..50},
    format: {
      with: /\A[\w\ \&\(\)\-]+\z/,
      message: "can only contain alphabet, number, parentheses,and &-_"
    }

  validates :description, length: {in: 0..280}

  validates :value_type, presence: true
  enum value_type: {text: "text", number: "number"}, _default: "text"
end
