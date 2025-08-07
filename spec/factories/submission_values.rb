FactoryBot.define do
  factory :submission_value do
    value do
      if question.text?
        Faker::Name.unique.name
      elsif question.number?
        Faker::Number.unique.between(from: 1, to: 1000)
      end
    end

    association :submission, factory: :submission
    association :question, factory: :question
  end
end
