require 'spec_helper'

describe SystemUser do
  it "should be valid" do
    build(:system_user).should be_valid
  end

  it 'should hash new password' do
    create(:system_user, new_password: 'test').hashed_password.should be_present
  end

  describe 'JSON for Chef' do
    specify 'create action' do
      system_user = create(:system_user, name: 'site', uid: 1001, system_group: create(:system_group, name: 'webuser'),
                           system_user_shell: create(:system_user_shell, name: 'bash', path: '/usr/local/bin/bash'))
      expect(JSON.parse(system_user.to_chef_json(:create))).to(
          match_json_expression(
              {
                  "name":"site",
                  "group":"webuser",
                  "uid":1001,
                  "shell":"/usr/local/bin/bash",
                  "type":"system_user",
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
