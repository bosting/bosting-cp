require 'spec_helper'

describe IpAddress do
  it 'should be valid' do
    build(:ip_address).should be_valid
  end
end
