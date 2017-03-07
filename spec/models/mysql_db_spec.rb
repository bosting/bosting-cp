require 'spec_helper'

describe MysqlDb do
  before(:each) { MysqlDb.delete_all }

  it 'should be valid' do
    expect(create(:mysql_db_with_similar_name)).to be_valid
  end

  it 'should be unique' do
    system_user = create(:system_user, name: 'db_uniq')
    apache = create(:apache, system_user: system_user)
    mysql_user = create(:mysql_user_with_new_password, login: 'db_uniq', apache: apache)
    expect(create(:mysql_db, mysql_user: mysql_user, db_name: 'db_uniq')).to be_valid
    expect(build(:mysql_db, mysql_user: mysql_user, db_name: 'db_uniq')).not_to be_valid
  end

  it 'should validate db name' do
    system_user = create(:system_user, name: 'haribol')
    apache = create(:apache, system_user: system_user)
    mysql_user = create(:mysql_user_with_new_password, login: 'haribol', apache: apache)
    expect(build(:mysql_db, db_name: 'haribol', mysql_user: mysql_user)).to be_valid
    expect(build(:mysql_db, db_name: 'haribol2', mysql_user: mysql_user)).to be_valid
    expect(build(:mysql_db, db_name: 'haribol_2', mysql_user: mysql_user)).to be_valid
    expect(build(:mysql_db, db_name: 'bolobolo', mysql_user: mysql_user)).not_to be_valid
  end

  describe 'JSON for Chef' do
    before(:all) do
      apache = create(:apache)
      @login = apache.system_user.name
      mysql_user = create(:mysql_user, login: @login, new_password: 'passw0rd', apache: apache)
      @db_name = "#{@login}_db"
      @mysql_db = create(:mysql_db, db_name: @db_name, mysql_user: mysql_user)
    end

    specify 'create action' do
      expect(JSON.parse(@mysql_db.to_chef_json(:create))).to(
        match_json_expression(
          "db_name": @db_name,
          "mysql_user": @login,
          "type": 'mysql_db',
          "action": 'create'
        )
      )
    end

    specify 'destroy action' do
      expect(JSON.parse(@mysql_db.to_chef_json(:destroy))).to(
        match_json_expression(
          "db_name": @db_name,
          "mysql_user": @login,
          "type": 'mysql_db',
          "action": 'destroy'
        )
      )
    end
  end
end
