FactoryBot.define do
  factory :user do
    email
    password 'password'
    password_confirmation(&:password)

    factory :admin_user do
      is_admin true
    end

    factory :edit_user
  end
end
