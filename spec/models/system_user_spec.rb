require 'spec_helper'

describe SystemUser do
  it 'should be valid' do
    build(:system_user).should be_valid
  end

  it 'should not be valid if uid is too low' do
    expect(build(:system_user, uid: 4_000)).not_to be_valid
  end

  it 'should not be valid if uid is too high' do
    expect(build(:system_user, uid: 65_200)).not_to be_valid
  end

  it 'should hash new password' do
    create(:system_user, new_password: 'test').hashed_password.should be_present
  end

  describe 'uid' do
    it 'should be 5000 if it is the first system user' do
      SystemUser.stubs(:maximum).returns(nil)
      system_user = build(:system_user)
      system_user.set_defaults
      expect(system_user.uid).to eq(5_000)
    end

    it 'should be higher than maximum' do
      SystemUser.stubs(:maximum).returns(5_005)
      system_user = build(:system_user)
      system_user.set_defaults
      expect(system_user.uid).to eq(5_006)
    end
  end

  describe 'JSON for Chef' do
    before(:all) { @system_group = create(:system_group, name: 'webuser') }

    specify 'create action' do
      system_user = create(:system_user, name: 'site', uid: 5_001,
                           system_group: @system_group,
                           system_user_shell:
                             create(:system_user_shell, name: 'bash',
                                    path: '/usr/local/bin/bash'))
      system_user.stubs(:hashed_password).returns('hashed_password')
      expect(JSON.parse(system_user.to_chef_json(:create))).to(
        match_json_expression(
          'name': 'site',
          'group': 'webuser',
          'uid': 5_001,
          'shell': '/usr/local/bin/bash',
          'chroot_directory': '',
          'hashed_password': 'hashed_password',
          'type': 'system_user',
          'action': 'create'
        )
      )
    end

    specify 'destroy action' do
      system_user = create(:system_user, name: 'site2', uid: 5_002,
                           system_group: @system_group,
                           system_user_shell:
                             create(:system_user_shell, name: 'bash',
                                    path: '/usr/local/bin/bash'))
      expect(JSON.parse(system_user.to_chef_json(:destroy))).to(
        match_json_expression(
          'name': 'site2',
          'chroot_directory': '',
          'type': 'system_user',
          'action': 'destroy'
        )
      )
    end

    it 'should add chroot directory if apache is present' do
      system_user = create(:system_user, name: 'site3', uid: 5_003,
                           system_group: @system_group,
                           system_user_shell:
                             create(:system_user_shell, name: 'bash',
                                    path: '/usr/local/bin/bash'))
      system_user.stubs(:hashed_password).returns('hashed_password')
      apache_variation = create(:apache_variation, name: 'apache22_php56')
      create(:apache, system_user: system_user,
             apache_variation: apache_variation)
      expect(JSON.parse(system_user.to_chef_json(:create))).to(
        match_json_expression(
          'name': 'site3',
          'group': 'webuser',
          'uid': 5_003,
          'shell': '/usr/local/bin/bash',
          'chroot_directory': '/usr/jails/apache22_php56',
          'hashed_password': 'hashed_password',
          'type': 'system_user',
          'action': 'create'
        )
      )
    end

    it 'should set nologin shell if inside apache variation' do
      system_user = create(:system_user, name: 'site4', uid: 5_004,
                           system_group: @system_group,
                           system_user_shell:
                             create(:system_user_shell, name: 'bash',
                                    path: '/usr/local/bin/bash'))
      system_user.stubs(:hashed_password).returns('hashed_password')
      apache_variation = create(:apache_variation, name: 'apache22_php56')
      create(:apache, system_user: system_user, apache_variation: apache_variation)
      expect(JSON.parse(system_user.to_chef_json(:create, apache_variation))).to(
        match_json_expression(
          'name': 'site4',
          'group': 'webuser',
          'uid': 5_004,
          'shell': '/sbin/nologin',
          'chroot_directory': '',
          'hashed_password': 'hashed_password',
          'type': 'system_user',
          'action': 'create'
        )
      )
    end
  end
end
