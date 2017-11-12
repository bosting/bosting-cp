FactoryBot.define do
  factory :system_user do
    name { generate(:login) }
    system_group
    sequence(:uid) { |n| 5000 + n }
    user
    system_user_shell
  end
end
