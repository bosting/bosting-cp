require 'spec_helper'

describe User do
  it "should be valid" do
    build(:user).should be_valid
  end
end
