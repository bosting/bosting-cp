require 'spec_helper'

RSpec.describe Setting, type: :model do
  it "should be valid" do
    build(:setting).should be_valid
  end

  it "should get true value" do
    create(:setting, name: 'true_value', value: true, value_type: Setting::TYPES[:boolean])
    Setting.get('true_value').should == true
  end

  it "should get false value" do
    create(:setting, name: 'false_value', value: false, value_type: Setting::TYPES[:boolean])
    Setting.get('false_value').should == false
  end

  it "should get integer value" do
    create(:setting, name: 'integer_value', value: 1, value_type: Setting::TYPES[:integer])
    Setting.get('integer_value').should == 1
  end
end
