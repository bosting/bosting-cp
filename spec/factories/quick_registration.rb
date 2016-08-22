FactoryGirl.define do
  factory :quick_registration do
    sequence(:domain) { |n| "example#{n}.com" }
    login
    email
    apache_variation { create(:apache_variation).id }
    ip_address { create(:ip_address).id }
    ns1_ip_address 1
    ns2_ip_address 2

    factory :quick_registration_with_user do
      user { create(:user).id }
    end
  end
end
