FactoryBot.define do
  factory :pgsql_db do
    db_name
    association :pgsql_user, factory: :pgsql_user_with_new_password

    factory :pgsql_db_with_similar_name do
      sequence(:db_name) { |n| "#{pgsql_user.login}_#{n}" }
    end
  end
end
