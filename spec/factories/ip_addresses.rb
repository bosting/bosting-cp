FactoryGirl.define do
  factory :ip_address do
    sequence(:name) { generate(:user_name) }
    ip '192.168.0.1'
  end
end
