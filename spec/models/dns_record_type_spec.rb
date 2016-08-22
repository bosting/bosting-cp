require 'spec_helper'

describe DnsRecordType do
  it "should be valid" do
    build(:dns_record_type).should be_valid
  end
end
