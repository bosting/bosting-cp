FactoryGirl.define do
  factory :user do
    email
    password 'password'
    password_confirmation { |u| u.password }

    factory :admin_user do
      is_admin true
    end

    factory :edit_user
  end
end
