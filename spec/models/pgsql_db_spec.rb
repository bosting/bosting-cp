require 'spec_helper'

describe PgsqlDb do
  before(:each) { PgsqlDb.delete_all }

  it 'should be valid' do
    expect(create(:pgsql_db_with_similar_name)).to be_valid
  end

  it 'should be unique' do
    system_user = create(:system_user, name: 'db_uniq')
    apache = create(:apache, system_user: system_user)
    pgsql_user = create(:pgsql_user_with_new_password, login: 'db_uniq', apache: apache)
    expect(create(:pgsql_db, pgsql_user: pgsql_user, db_name: 'db_uniq')).to be_valid
    expect(build(:pgsql_db, pgsql_user: pgsql_user, db_name: 'db_uniq')).not_to be_valid
  end

  it 'should validate db name' do
    system_user = create(:system_user, name: 'haribol')
    apache = create(:apache, system_user: system_user)
    pgsql_user = create(:pgsql_user_with_new_password, login: 'haribol', apache: apache)
    expect(build(:pgsql_db, db_name: 'haribol', pgsql_user: pgsql_user)).to be_valid
    expect(build(:pgsql_db, db_name: 'haribol2', pgsql_user: pgsql_user)).to be_valid
    expect(build(:pgsql_db, db_name: 'haribol_2', pgsql_user: pgsql_user)).to be_valid
    expect(build(:pgsql_db, db_name: 'bolobolo', pgsql_user: pgsql_user)).not_to be_valid
  end

  describe 'JSON for Chef' do
    before(:all) do
      apache = create(:apache)
      @login = apache.system_user.name
      pgsql_user = create(:pgsql_user, login: @login, new_password: 'passw0rd', apache: apache)
      @db_name = "#{@login}_db"
      @pgsql_db = create(:pgsql_db, db_name: @db_name, pgsql_user: pgsql_user)
    end

    specify 'create action' do
      expect(JSON.parse(@pgsql_db.to_chef_json(:create))).to(
        match_json_expression(
          "db_name": @db_name,
          "pgsql_user": @login,
          "type": 'pgsql_db',
          "action": 'create'
        )
      )
    end

    specify 'destroy action' do
      expect(JSON.parse(@pgsql_db.to_chef_json(:destroy))).to(
        match_json_expression(
          "db_name": @db_name,
          "pgsql_user": @login,
          "type": 'pgsql_db',
          "action": 'destroy'
        )
      )
    end
  end
end
