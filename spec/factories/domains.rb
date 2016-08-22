FactoryGirl.define do
  factory :domain do
    name { generate(:domain) }
    email
    association :ns1_ip_address, factory: :ip_address
    association :ns2_ip_address, factory: :ip_address
  end
end
