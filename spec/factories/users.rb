FactoryBot.define do
  sequence(:username_factory) { |n| "person#{n}" }
  factory :user do
    email { "#{generate(:username_factory)}@example.com" }
    password { "password123" }
  end
end
