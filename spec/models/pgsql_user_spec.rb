require 'spec_helper'

describe PgsqlUser do
  it "should be valid with a new password" do
    create(:pgsql_user_with_new_password).should be_valid
  end

  it "should be not valid without a new password" do
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

    it 'should leave old hash' do
      apache = create(:apache, system_user: create(:system_user, name: 'login2'))
      pgsql_user = create(:pgsql_user, apache: apache, login: 'login2', new_password: 'test')
      pgsql_user.save
      pgsql_user.hashed_password.should == 'md5124653cf9d6a29a3d4b5f264b1105dec'
    end
  end

  it 'should mark as deleted the pgsql user and all pgsql dbs' do
    pgsql_user = create(:pgsql_user_with_new_password)
    pgsql_db1 = create(:pgsql_db_with_similar_name, pgsql_user: pgsql_user)
    pgsql_db2 = create(:pgsql_db_with_similar_name, pgsql_user: pgsql_user)
    pgsql_user.destroy
    pgsql_user.reload.is_deleted.should be_truthy
    pgsql_db1.reload.is_deleted.should be_truthy
    pgsql_db2.reload.is_deleted.should be_truthy
  end

  it 'should create a db with the same name' do
    system_user = create(:system_user, name: 'new_user')
    apache = create(:apache, system_user: system_user)
    pgsql_user = create(:pgsql_user_with_new_password, login: 'new_user', create_db: true, apache: apache)
    pgsql_user.pgsql_dbs.first.db_name.should == 'new_user'
  end

  it 'should validate the user name to be similar to apache name' do
    system_user = create(:system_user, name: 'pgsql')
    apache = create(:apache, system_user: system_user)
    expect(build(:pgsql_user_with_new_password, login: 'pgsql', apache: apache)).to be_valid
    expect(build(:pgsql_user_with_new_password, login: 'john', apache: apache)).not_to be_valid
  end
end
