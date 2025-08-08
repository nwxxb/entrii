FactoryBot.define do
  factory :submission do
    association :questionnaire, factory: :questionnaire
  end
end
