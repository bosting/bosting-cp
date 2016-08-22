FactoryGirl.define do
  sequence(:email) { |n| "user#{n}@example.com" }
  sequence(:domain) { |n| "example#{n}.com" }
  sequence(:login) { |n| "user_#{n}" }
  sequence(:user_name) { |n| "User #{n}" }
  sequence(:group_name) { |n| "Group #{n}" }
  sequence(:db_name) { |n| "db_#{n}" }
end
