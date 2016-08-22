require 'spec_helper'

describe Registrar do
  it "should be valid" do
    build(:registrar).should be_valid
  end
end
