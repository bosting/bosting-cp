require 'spec_helper'

describe RailsServer do
  it 'should be valid' do
    expect(create(:rails_server)).to be_valid
  end
end
