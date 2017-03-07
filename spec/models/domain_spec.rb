require 'spec_helper'

describe Domain do
  before(:all) { create_dns_record_types }

  it 'should be valid' do
    create(:domain).should be_valid
  end

  it 'should be valid when adding default records' do
    create(:domain, add_default_records: '1').should be_valid
  end

  it 'should be valid when adding gmail mx records' do
    create(:domain, add_gmail_mx_records: '1').should be_valid
  end

  it 'should set serial' do
    domain = create(:domain)
    expect(domain.serial).to eq('2008090140')
    domain.save
    expect(domain.serial).to eq('2008090141')
    domain.save
    expect(domain.serial).to eq('2008090142')
  end
end
