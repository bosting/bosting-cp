FactoryBot.define do
  factory :system_group do
    name { generate(:group_name) }
    sequence(:gid) { |n| n }
  end
end
