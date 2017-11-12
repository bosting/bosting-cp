FactoryBot.define do
  factory :pgsql_user do
    apache
    sequence(:login) { |i| "#{apache.system_user.name}_#{i}" }

    factory :pgsql_user_with_new_password do
      new_password 'new password'
    end

    factory :pgsql_user_without_apache do
      apache nil
      login 'login'
    end

    factory :pgsql_user_with_a_rails_server do
      apache nil
      rails_server
      sequence(:login) { |i| "#{rails_server.name}_#{i}" }

      factory :pgsql_user_with_a_rails_server_and_a_new_password do
        new_password 'new password'
      end
    end
  end
end
