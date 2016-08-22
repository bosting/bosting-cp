require 'spec_helper'

describe EmailDomain do
  it 'should be valid' do
    create(:email_domain).should be_valid
  end

  it 'should create a hidden catch-all alias' do
    email_domain = create(:email_domain, name: 'example.org')
    email_domain.email_aliases.count.should == 0
    email_domain.email_aliases.rewhere(hidden: true).count.should == 1
  end
end
