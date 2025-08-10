FactoryBot.define do
  factory :submission_value do
    value do
      if question.text?
        Faker::Name.unique.name
      elsif question.number?
        Faker::Number.unique.between(from: 1, to: 1000)
      end
    end

    questionnaire { association :questionnaire }
    submission { association :submission, questionnaire: questionnaire }
    question { association :question, questionnaire: questionnaire }
  end
end
