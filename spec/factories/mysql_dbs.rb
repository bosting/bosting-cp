FactoryBot.define do
  factory :mysql_db do
    db_name
    association :mysql_user, factory: :mysql_user_with_new_password

    factory :mysql_db_with_similar_name do
      sequence(:db_name) { |n| "#{mysql_user.login}_#{n}" }
    end
  end
end
