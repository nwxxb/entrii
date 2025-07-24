FactoryBot.define do
  sequence(:questionnaire_title_factory) { |n| "form #{n}" }
  factory :questionnaire do
    title { generate(:questionnaire_title_factory) }
    description { "description for #{title}" }
    association :user, factory: :user
  end
end
