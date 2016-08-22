require 'spec_helper'

describe Domain do
  before(:all) { create_dns_record_types }

  it "should be valid" do
    create(:domain).should be_valid
  end

  it "should be valid when adding default records" do
    create(:domain, add_default_records: '1').should be_valid
  end

  it "should be valid when adding gmail mx records" do
    create(:domain, add_gmail_mx_records: '1').should be_valid
  end

  it "should set serial" do
    domain = create(:domain)
    domain.serial.should == '2008090140'
    domain.save
    domain.serial.should == '2008090141'
    domain.save
    domain.serial.should == '2008090142'
  end

  it "should set updated if active" do
    domain = create(:domain, active: true)
    domain.update_column(:updated, false)
    domain.updated.should be_falsey
    domain.save!
    domain.updated.should be_truthy
  end

  it "should not set updated if not active" do
    domain = create(:domain, active: false)
    domain.update_column(:updated, false)
    domain.updated.should be_falsey
    domain.save!
    domain.updated.should be_falsey
  end

  it 'should mark as deleted the domain and all dns records' do
    domain = create(:domain)
    dns_record1 = create(:dns_record, domain: domain)
    dns_record2 = create(:dns_record, domain: domain)
    domain.destroy
    domain.reload.is_deleted.should be_truthy
    dns_record1.reload.is_deleted.should be_truthy
    dns_record2.reload.is_deleted.should be_truthy
  end
end
