require 'spec_helper'

describe RailsServerAlias do
  it 'should be valid' do
    expect(create(:rails_server_alias)).to be_valid
  end
end
