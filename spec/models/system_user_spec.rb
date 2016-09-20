require 'spec_helper'

describe SystemUser do
  it "should be valid" do
    build(:system_user).should be_valid
  end

  it 'should hash new password' do
    create(:system_user, new_password: 'test').hashed_password.should be_present
  end

  describe 'uid' do
    it 'should be 2000 if it is the first system user' do
      SystemUser.stubs(:maximum).returns(nil)
      system_user = build(:system_user)
      system_user.set_defaults
      system_user.uid.should == 2000
    end

    it 'should be higher than maximum' do
      SystemUser.stubs(:maximum).returns(2005)
      system_user = build(:system_user)
      system_user.set_defaults
      system_user.uid.should == 2006
    end
  end

  describe 'JSON for Chef' do
    specify 'create action' do
      system_user = create(:system_user, name: 'site', uid: 1001, system_group: create(:system_group, name: 'webuser'),
                           system_user_shell: create(:system_user_shell, name: 'bash', path: '/usr/local/bin/bash'))
      system_user.stubs(:hashed_password).returns('hashed_password')
      expect(JSON.parse(system_user.to_chef_json(:create))).to(
          match_json_expression(
              {
                  "name":"site",
                  "group":"webuser",
                  "uid":1001,
                  "shell":"/usr/local/bin/bash",
                  "type":"system_user",
                  "hashed_password":"hashed_password",
                  "action":"create"
              }
          )
      )
    end

    specify 'destroy action' do
      system_user = create(:system_user, name: 'site2', uid: 1002, system_group: create(:system_group, name: 'webuser'),
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
