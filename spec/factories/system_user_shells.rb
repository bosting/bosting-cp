# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :system_user_shell do
    name "MyString"
    path "MyString"
    is_default false
  end
end
