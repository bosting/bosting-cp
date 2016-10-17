require 'spec_helper'

describe SystemGroup do
  it 'should be valid' do
    build(:system_group).should be_valid
  end
end
