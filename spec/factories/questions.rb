FactoryBot.define do
  sequence(:question_name_factory) { |n| "question #{n}" }
  factory :question do
    name { generate(:question_name_factory) }
    description { "description for #{name}" }
    is_emptyable { false }
    position { 0 }

    traits_for_enum(:value_type)
    association :questionnaire, factory: :questionnaire
  end
end
