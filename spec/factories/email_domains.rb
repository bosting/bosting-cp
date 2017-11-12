FactoryBot.define do
  factory :email_domain do
    sequence(:name) { |n| "example#{n}.com" }
    user
  end
end
