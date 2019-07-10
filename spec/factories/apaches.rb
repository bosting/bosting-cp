FactoryBot.define do
  factory :apache do
    user
    system_user
    system_group
    ip_address
    start_servers 1
    min_spare_servers 1
    max_spare_servers 1
    max_clients 4
    server_admin 'mail@example.com'
    apache_variation
    custom_config { '# some custom config' }

    factory :apache_without_system_user_and_user do
      user nil
      system_user nil
    end
  end
end
