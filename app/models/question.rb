class Question < ApplicationRecord
  include Discard::Model

  belongs_to :questionnaire
  has_many :submission_values

  def mark_for_destruction
    if submission_values.any?
      discard!
      @marked_for_destruction = false
    else
      @marked_for_destruction = true
    end
  end

  validates :name,
    presence: true,
    length: {in: 1..50},
    format: {
      with: /\A[\w\ \&\(\)\-]+\z/,
      message: "can only contain alphabet, number, parentheses,and &-_"
    }

  validates :description, length: {in: 0..280}

  validates :value_type, presence: true
  enum value_type: {text: "text", number: "number", date: "date"}, _default: "text"

  # unfortunately, we can't use ruby's regex (even with to_s)
  def valid_pattern
    if number?
      '[\d.]*'
    else
      '[a-zA-Z0-9_\. \'\-\(\)]*'
    end
  end
end
