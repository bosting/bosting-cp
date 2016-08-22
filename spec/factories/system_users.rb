FactoryGirl.define do
  factory :system_user do
    name { generate(:login) }
    system_group
    sequence(:uid) { |n| n }
    user
    system_user_shell
  end
end
