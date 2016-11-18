require 'spec_helper'

describe PgsqlUser do
  it 'should be valid with a new password' do
    create(:pgsql_user_with_new_password).should be_valid
  end

  it 'should be not valid without a new password' do
    build(:pgsql_user).should_not be_valid
  end

  it 'should not be valid without apache or rails server' do
    build(:pgsql_user_without_apache).should_not be_valid
  end

  it 'should not be valid with a rails server' do
    build(:pgsql_user_with_a_rails_server).should_not be_valid
  end

  it 'should be valid with a rails server and a new password' do
    build(:pgsql_user_with_a_rails_server_and_a_new_password).should be_valid
  end

  describe 'password hashing' do
    it 'should hash new password' do
      apache = create(:apache, system_user: create(:system_user, name: 'login'))
      create(:pgsql_user, apache: apache, login: 'login', new_password: 'test').hashed_password.should == 'md5eacdbf8d9847a76978bd515fae200a2a'
    end

    it 'should not change old hash' do
      pgsql_user = create(:pgsql_user_with_new_password)
      expect{ pgsql_user.save }.not_to change{ pgsql_user.hashed_password }
    end
  end

  it 'should validate the user name to be similar to apache name' do
    system_user = create(:system_user, name: 'pgsql')
    apache = create(:apache, system_user: system_user)
    expect(build(:pgsql_user_with_new_password, login: 'pgsql', apache: apache)).to be_valid
    expect(build(:pgsql_user_with_new_password, login: 'john', apache: apache)).not_to be_valid
  end

  describe 'JSON for Chef' do
    before(:all) do
      apache = create(:apache)
      @login = apache.system_user.name
      @pgsql_user = create(:pgsql_user, login: @login, new_password: 'passw0rd', apache: apache)
    end
    before(:each) { PgsqlUser.any_instance.stubs(:hashed_password).returns('md5hashedpassword') }

    specify 'create action' do
      expect(JSON.parse(@pgsql_user.to_chef_json(:create))).to(
          match_json_expression(
              {
                  "login":@login,
                  "hashed_password":"md5hashedpassword",
                  "type":"pgsql_user",
                  "action":"create"
              }
          )
      )
    end

    specify 'destroy action' do
      expect(JSON.parse(@pgsql_user.to_chef_json(:destroy))).to(
          match_json_expression(
              {
                  "login":@login,
                  "type":"pgsql_user",
                  "action":"destroy"
              }
          )
      )
    end
  end
end
