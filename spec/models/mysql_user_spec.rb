require 'spec_helper'

describe MysqlUser do
  it 'should be valid with a new password' do
    create(:mysql_user_with_new_password).should be_valid
  end

  it 'should be not valid without a new password' do
    build(:mysql_user).should_not be_valid
  end

  it 'should not be valid without apache or rails server' do
    build(:mysql_user_without_apache).should_not be_valid
  end

  it 'should not be valid with a rails server' do
    build(:mysql_user_with_a_rails_server).should_not be_valid
  end

  it 'should be valid with a rails server and a new password' do
    build(:mysql_user_with_a_rails_server_and_a_new_password).should be_valid
  end

  describe 'password hashing' do
    it 'should hash new password' do
      expect(create(:mysql_user, new_password: 'test').hashed_password)
        .to eq('*94BDCEBE19083CE2A1F959FD02F964C7AF4CFC29')
    end

    it 'should not change old hash' do
      mysql_user = create(:mysql_user, new_password: 'test')
      expect { mysql_user.save }.not_to change { mysql_user.hashed_password }
    end
  end

  it 'should validate the user name to be similar to apache name' do
    system_user = create(:system_user, name: 'mysql')
    apache = create(:apache, system_user: system_user)
    expect(build(:mysql_user_with_new_password, login: 'mysql', apache: apache)).to be_valid
    expect(build(:mysql_user_with_new_password, login: 'john', apache: apache)).not_to be_valid
  end

  describe 'JSON for Chef' do
    before(:all) do
      apache = create(:apache)
      @login = apache.system_user.name
      @mysql_user = create(:mysql_user, login: @login, new_password: 'passw0rd', apache: apache)
    end
    before(:each) { MysqlUser.any_instance.stubs(:hashed_password).returns('*HASHEDPASSWORD') }

    specify 'create action' do
      expect(JSON.parse(@mysql_user.to_chef_json(:create))).to(
        match_json_expression(
          "login": @login,
          "hashed_password": '*HASHEDPASSWORD',
          "type": 'mysql_user',
          "action": 'create'
        )
      )
    end

    specify 'destroy action' do
      expect(JSON.parse(@mysql_user.to_chef_json(:destroy))).to(
        match_json_expression(
          "login": @login,
          "type": 'mysql_user',
          "action": 'destroy'
        )
      )
    end
  end
end
