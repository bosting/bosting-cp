FactoryBot.define do
  factory :setting do
    sequence(:name) { |n| "setting#{n}" }
    value 'some value'
    value_type 3 # string
  end
end
