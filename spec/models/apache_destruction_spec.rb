require 'spec_helper'

describe ApacheDestruction do
  it 'should be valid' do
    expect(build(:apache_destruction)).to be_valid
  end

  it 'should destroy dependencies' do
    apache_destruction = build(:apache_destruction,
                               destroy_domains: true,
                               destroy_ftps: true,
                               destroy_user: true,
                               destroy_system_user: true,
                               destroy_mysql_users: true,
                               destroy_pgsql_users: true)

    apache = create(:apache)
    user = create(:user, apaches: [apache])
    system_user = create(:system_user, apaches: [apache])
    domain = create(:domain, user: user)
    ftp = create(:ftp, system_user: system_user)
    mysql_user1 = create(:mysql_user_with_new_password, apache: apache)
    mysql_user2 = create(:mysql_user_with_new_password, apache: apache)
    mysql_db1 = create(:mysql_db, db_name: mysql_user1.name, mysql_user: mysql_user1)
    mysql_db2 = create(:mysql_db, db_name: mysql_user2.name, mysql_user: mysql_user2)
    pgsql_user1 = create(:pgsql_user_with_new_password, apache: apache)
    pgsql_user2 = create(:pgsql_user_with_new_password, apache: apache)
    pgsql_db1 = create(:pgsql_db, db_name: pgsql_user1.name, pgsql_user: pgsql_user1)
    pgsql_db2 = create(:pgsql_db, db_name: pgsql_user2.name, pgsql_user: pgsql_user2)

    apache_destruction.destroy_dependencies(apache)

    expect(User.exists?(user.id)).to eq(false)
    expect(Ftp.exists?(ftp.id)).to eq(false)
    expect(SystemUser.exists?(system_user.id)).to eq(false)
    expect(Domain.exists?(domain.id)).to eq(false)
    expect(MysqlUser.exists?(mysql_user1.id)).to eq(false)
    expect(MysqlUser.exists?(mysql_user2.id)).to eq(false)
    expect(MysqlDb.exists?(mysql_db1.id)).to eq(false)
    expect(MysqlDb.exists?(mysql_db2.id)).to eq(false)
    expect(PgsqlUser.exists?(pgsql_user1.id)).to eq(false)
    expect(PgsqlUser.exists?(pgsql_user2.id)).to eq(false)
    expect(PgsqlDb.exists?(pgsql_db1.id)).to eq(false)
    expect(PgsqlDb.exists?(pgsql_db2.id)).to eq(false)
  end

  it 'should not destroy dependencies' do
    apache_destruction = build(:apache_destruction,
                               destroy_domains: false,
                               destroy_ftps: false,
                               destroy_user: false,
                               destroy_system_user: false,
                               destroy_mysql_users: false,
                               destroy_pgsql_users: false)

    apache = create(:apache)
    user = create(:user, apaches: [apache])
    system_user = create(:system_user, apaches: [apache])
    domain = create(:domain, user: user)
    ftp = create(:ftp, system_user: system_user)
    mysql_user1 = create(:mysql_user_with_new_password, apache: apache)
    mysql_user2 = create(:mysql_user_with_new_password, apache: apache)
    mysql_db1 = create(:mysql_db, db_name: mysql_user1.name, mysql_user: mysql_user1)
    mysql_db2 = create(:mysql_db, db_name: mysql_user2.name, mysql_user: mysql_user2)
    pgsql_user1 = create(:pgsql_user_with_new_password, apache: apache)
    pgsql_user2 = create(:pgsql_user_with_new_password, apache: apache)
    pgsql_db1 = create(:pgsql_db, db_name: pgsql_user1.name, pgsql_user: pgsql_user1)
    pgsql_db2 = create(:pgsql_db, db_name: pgsql_user2.name, pgsql_user: pgsql_user2)

    apache_destruction.destroy_dependencies(apache)

    expect(User.exists?(user.id)).to eq(true)
    expect(Ftp.exists?(ftp.id)).to eq(true)
    expect(SystemUser.exists?(system_user.id)).to eq(true)
    expect(Domain.exists?(domain.id)).to eq(true)
    expect(MysqlUser.exists?(mysql_user1.id)).to eq(true)
    expect(MysqlUser.exists?(mysql_user2.id)).to eq(true)
    expect(MysqlDb.exists?(mysql_db1.id)).to eq(true)
    expect(MysqlDb.exists?(mysql_db2.id)).to eq(true)
    expect(PgsqlUser.exists?(pgsql_user1.id)).to eq(true)
    expect(PgsqlUser.exists?(pgsql_user2.id)).to eq(true)
    expect(PgsqlDb.exists?(pgsql_db1.id)).to eq(true)
    expect(PgsqlDb.exists?(pgsql_db2.id)).to eq(true)
  end
end
