require 'spec_helper'

describe Domain do
  before { create_dns_record_types }

  it 'is be valid' do
    expect(create(:domain)).to be_valid
  end

  it 'is valid when adding default records' do
    expect(create(:domain, add_default_records: '1')).to be_valid
  end

  it 'is valid when adding gmail mx records' do
    expect(create(:domain, add_gmail_mx_records: '1')).to be_valid
  end

  it 'increases serial' do
    domain = create(:domain)
    expect(domain.serial).to eq('2008090140')
    domain.save
    expect(domain.serial).to eq('2008090141')
    domain.save
    expect(domain.serial).to eq('2008090142')
  end
end
