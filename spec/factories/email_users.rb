FactoryGirl.define do
  factory :email_user do
    email_domain
    username { generate(:login) }
    password 'password'
  end
end
