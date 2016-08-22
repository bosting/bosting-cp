require 'spec_helper'

describe Ftp do
  it "should be valid" do
    create(:ftp).should be_valid
  end
end
