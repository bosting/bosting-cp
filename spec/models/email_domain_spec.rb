require 'spec_helper'

describe EmailDomain do
  it 'should be valid' do
    create(:email_domain).should be_valid
  end

  it 'should create a hidden catch-all alias' do
    email_domain = create(:email_domain, name: 'example.org')
    expect(email_domain.email_aliases.count).to eq(0)
    expect(email_domain.email_aliases.rewhere(hidden: true).count).to eq(1)
  end
end
