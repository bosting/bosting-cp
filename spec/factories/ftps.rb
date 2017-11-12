FactoryBot.define do
  factory :ftp do
    User { generate(:user_name) }
    new_password 'new password'
    system_user
    Dir '/home/user'
  end
end
