require 'spec_helper'

describe SystemUser do
  it "should be valid" do
    build(:system_user).should be_valid
  end

  it "should not be valid if uid is too low" do
    expect(build(:system_user, uid: 4000)).not_to be_valid
  end

  it "should not be valid if uid is too high" do
    expect(build(:system_user, uid: 65200)).not_to be_valid
  end

  it 'should hash new password' do
    create(:system_user, new_password: 'test').hashed_password.should be_present
  end

  describe 'uid' do
    it 'should be 5000 if it is the first system user' do
      SystemUser.stubs(:maximum).returns(nil)
      system_user = build(:system_user)
      system_user.set_defaults
      system_user.uid.should == 5000
    end

    it 'should be higher than maximum' do
      SystemUser.stubs(:maximum).returns(5005)
      system_user = build(:system_user)
      system_user.set_defaults
      system_user.uid.should == 5006
    end
  end

  describe 'JSON for Chef' do
    before(:all) { @system_group = create(:system_group, name: 'webuser') }

    specify 'create action' do
      system_user = create(:system_user, name: 'site', uid: 5001, system_group: @system_group,
                           system_user_shell: create(:system_user_shell, name: 'bash', path: '/usr/local/bin/bash'))
      system_user.stubs(:hashed_password).returns('hashed_password')
      expect(JSON.parse(system_user.to_chef_json(:create))).to(
          match_json_expression(
              {
                  "name":"site",
                  "group":"webuser",
                  "uid":5001,
                  "shell":"/usr/local/bin/bash",
                  "type":"system_user",
                  "hashed_password":"hashed_password",
                  "action":"create"
              }
          )
      )
    end

    specify 'destroy action' do
      system_user = create(:system_user, name: 'site2', uid: 5002, system_group: @system_group,
                           system_user_shell: create(:system_user_shell, name: 'bash', path: '/usr/local/bin/bash'))
      expect(JSON.parse(system_user.to_chef_json(:destroy))).to(
          match_json_expression(
              {
                  "name":"site2",
                  "type":"system_user",
                  "action":"destroy"
              }
          )
      )
    end
  end
end
