FactoryBot.define do
  factory :email_alias do
    email_domain
    username { generate(:login) }
    destination 'somewhere@example.com'
  end
end
