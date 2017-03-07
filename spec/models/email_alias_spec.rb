require 'spec_helper'

describe EmailAlias do
  it 'should be valid' do
    create(:email_alias).should be_valid
  end

  it 'should cache full email address' do
    email_domain = create(:email_domain, name: 'example.com')
    email_alias = create(:email_alias, username: 'john', email_domain: email_domain)
    expect(email_alias.email).to eq('john@example.com')
  end
end
