require 'spec_helper'

describe VhostAlias do
  it 'should be valid' do
    expect(create(:vhost_alias)).to be_valid
  end
end
