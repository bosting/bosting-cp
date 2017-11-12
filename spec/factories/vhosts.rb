FactoryBot.define do
  factory :vhost do
    apache
    server_name { generate(:domain) }
    directory_index 'index.html'

    factory :vhost_ssl do
      ssl true
      ssl_ip_address { build(:ip_address) }
      ssl_port 443
      ssl_key 'key text'
      ssl_certificate 'cert text'
    end
  end
end
