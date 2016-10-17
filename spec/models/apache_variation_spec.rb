require 'spec_helper'

describe ApacheVariation do
  it 'should be valid' do
    build(:ip_address).should be_valid
  end
end
