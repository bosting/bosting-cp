require 'spec_helper'

describe DnsRecord do
  it 'should be valid' do
    build(:dns_record).should be_valid
  end
end
