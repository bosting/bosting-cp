require 'spec_helper'

describe Apache do
  before(:all) do
    create(:system_group, name: 'webuser')
    create_system_user_shells
    create_apache_variations
  end
  before(:each) { create(:system_user) }
  after(:each) { SystemUser.delete_all }

  it "should be valid" do
    build(:apache).should be_valid
  end

  it "should set updated if active" do
    apache = create(:apache, active: true)
    apache.update_column(:updated, false)
    apache.updated.should be_falsey
    apache.save!
    apache.updated.should be_truthy
  end

  it "should not set updated if not active" do
    apache = create(:apache, active: false)
    apache.update_column(:updated, false)
    apache.updated.should be_falsey
    apache.save!
    apache.updated.should be_falsey
  end

  it 'should mark as deleted the apache and all vhosts' do
    apache = create(:apache)
    vhost1 = create(:vhost, apache: apache)
    vhost2 = create(:vhost, apache: apache)
    apache.destroy
    apache.reload.is_deleted.should be_truthy
    vhost1.reload.is_deleted.should be_truthy
    vhost2.reload.is_deleted.should be_truthy
  end

  it 'should collect all server names' do
    apache = create(:apache)
    vhost1 = create(:vhost, server_name: 'host1.example.com', apache: apache)
    create(:vhost_alias, name: 'host2.example.com', vhost: vhost1)
    create(:vhost_alias, name: 'host3.example.com', vhost: vhost1)
    vhost2 = create(:vhost, server_name: 'host4.example.com', apache: apache)
    create(:vhost_alias, name: 'host5.example.com', vhost: vhost2)
    create(:vhost_alias, name: 'host6.example.com', vhost: vhost2)

    expect(apache.all_server_names.join(' ')).to eq('host1.example.com host2.example.com host3.example.com host4.example.com host5.example.com host6.example.com')
  end

  it 'should destroy dependencies' do
    apache = create(:apache)
    user = create(:user, apaches: [apache])
    system_user = create(:system_user, apaches: [apache])
    domain = create(:domain, user: user)
    ftp = create(:ftp, system_user: system_user)
    mysql_user1 = create(:mysql_user_with_new_password, apache: apache)
    mysql_user2 = create(:mysql_user_with_new_password, apache: apache)
    pgsql_user1 = create(:pgsql_user_with_new_password, apache: apache)
    pgsql_user2 = create(:pgsql_user_with_new_password, apache: apache)
    apache.destroy_ftps = '1'
    apache.destroy_domains = '1'
    apache.destroy_system_user = '1'
    apache.destroy_mysql_users = '1'
    apache.destroy_pgsql_users = '1'
    apache.destroy
    expect(User.exists?(user.id)).to be_truthy
    expect(Ftp.exists?(ftp.id)).to be_falsey
    expect(system_user.reload.is_deleted).to be_truthy
    expect(domain.reload.is_deleted).to be_truthy
    expect(mysql_user1.reload.is_deleted).to be_truthy
    expect(mysql_user2.reload.is_deleted).to be_truthy
    expect(pgsql_user1.reload.is_deleted).to be_truthy
    expect(pgsql_user2.reload.is_deleted).to be_truthy
  end

  it 'should not destroy dependencies' do
    apache = create(:apache)
    user = create(:user, apaches: [apache])
    system_user = create(:system_user, apaches: [apache])
    domain = create(:domain, user: user)
    ftp = create(:ftp, system_user: system_user)
    mysql_user1 = create(:mysql_user_with_new_password, apache: apache)
    mysql_user2 = create(:mysql_user_with_new_password, apache: apache)
    pgsql_user1 = create(:pgsql_user_with_new_password, apache: apache)
    pgsql_user2 = create(:pgsql_user_with_new_password, apache: apache)
    apache.destroy
    expect(User.exists?(user.id)).to be_truthy
    expect(Ftp.exists?(ftp.id)).to be_truthy
    expect(system_user.reload.is_deleted).to be_falsey
    expect(domain.reload.is_deleted).to be_falsey
    expect(mysql_user1.reload.is_deleted).to be_falsey
    expect(mysql_user2.reload.is_deleted).to be_falsey
    expect(pgsql_user1.reload.is_deleted).to be_falsey
    expect(pgsql_user2.reload.is_deleted).to be_falsey
  end

  it 'apache with no vhosts should be not active' do
    apache = create(:apache)
    expect(apache.vhosts.active.size).to eq(0)
    expect(Apache.active.where(id: apache.id).size).to eq(0)
  end

  it 'apache with no active or deleted vhosts should be not active' do
    vhost1 = create(:vhost, active: false)
    vhost2 = create(:vhost, is_deleted: true)
    apache = create(:apache, vhosts: [vhost1, vhost2])
    expect(apache.vhosts.active.size).to eq(0)
    expect(Apache.active.where(id: apache.id).size).to eq(0)
  end

  describe 'Apache variation' do
    describe 'change' do
      it 'should be changed if changed' do
        apache = create(:apache, apache_variation: ApacheVariation.first)
        apache.update_attribute(:apache_variation, ApacheVariation.last)
        apache.av_changed.should be_truthy
      end

      it 'should not be changed if new record' do
        apache = create(:apache)
        apache.av_changed.should be_falsey
      end

      it 'should not be changed if not changed' do
        apache = create(:apache)
        apache.save!
        apache.av_changed.should be_falsey
      end
    end

    describe 'previous' do
      it 'should be nil if new record' do
        apache = create(:apache)
        apache.apache_variation_prev.should be_nil
      end

      it 'should remember previous if changed' do
        apache = create(:apache, apache_variation: ApacheVariation.first)
        apache.update_attribute(:apache_variation, ApacheVariation.last)
        apache.apache_variation_prev.should == ApacheVariation.first
      end

      it 'should not remember previous if not changed' do
        apache = create(:apache)
        apache.save!
        apache.apache_variation_prev.should be_nil
      end
    end
  end

  describe 'JSON for Chef' do
    specify 'create action' do
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 2200, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site'),
                      system_group: create(:system_group, name: 'www'),
                      ip_address: create(:ip_address, ip: '10.0.0.4'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5'))
      expect(JSON.parse(apache.to_chef_json(:create))).to(
          match_json_expression(
              {
                  "server_admin":"admin@bosting.net",
                  "user":"site",
                  "group":"www",
                  "ip":"10.0.0.4",
                  "port":2200,
                  "apache_version":"22",
                  "php_version":"55",
                  "start_servers":1,
                  "min_spare_servers":1,
                  "max_spare_servers":2,
                  "max_clients":4,
                  "action":["create","enable","start","reload"]
              }
          )
      )
    end

    specify 'destroy action' do
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 2201, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site'),
                      system_group: create(:system_group, name: 'www'),
                      ip_address: create(:ip_address, ip: '10.0.0.4'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5'))
      expect(JSON.parse(apache.to_chef_json(:destroy))).to(
          match_json_expression(
              {
                  "user":"site",
                  "action":"destroy"
              }
          )
      )

    end
  end
end
