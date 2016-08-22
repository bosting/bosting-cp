FactoryGirl.define do
  factory :apache_variation do
    name 'apache22_php55'
    description 'Apache 2.2, PHP 5.5'
    sequence(:ip) { |n| "10.0.0.#{n}"}
    apache_version '2.2'
    php_version '5.5'
  end
end
