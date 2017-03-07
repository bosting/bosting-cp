require 'spec_helper'

describe EmailUser do
  it 'should be valid' do
    create(:email_user).should be_valid
  end

  it 'should cache full email address' do
    email_domain = create(:email_domain, name: 'example.com')
    email_user = create(:email_user, username: 'john', email_domain: email_domain)
    expect(email_user.email).to eq('john@example.com')
  end

  it 'should hash new password' do
    create(:email_user, new_password: 'test').password.should be_present
  end
end
