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

  it 'apache with no vhosts should be not active' do
    apache = create(:apache)
    expect(apache.vhosts.active.size).to eq(0)
    expect(Apache.active.where(id: apache.id).size).to eq(0)
  end

  describe 'port' do
    it 'should be 2000 if it is the first apache' do
      Apache.stubs(:maximum).returns(nil)
      apache = build(:apache)
      apache.set_defaults
      apache.port.should == 2000
    end

    it 'should be higher than maximum' do
      Apache.stubs(:maximum).returns(2005)
      apache = build(:apache)
      apache.set_defaults
      apache.port.should == 2006
    end
  end

  describe 'JSON for Chef' do
    specify 'create action' do
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 2200, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site'),
                      system_group: create(:system_group, name: 'www'),
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'))
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
                  "type":"apache",
                  "action":"create"
              }
          )
      )
    end

    specify 'create action with different apache variation' do
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 2201, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site'),
                      system_group: create(:system_group, name: 'www'),
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'))
      apache_variation = create(:apache_variation, apache_version: '2.4', php_version: '7.0', ip: '10.0.0.6')
      expect(JSON.parse(apache.to_chef_json(:create, apache_variation))).to(
          match_json_expression(
              {
                  "server_admin":"admin@bosting.net",
                  "user":"site",
                  "group":"www",
                  "ip":"10.0.0.6",
                  "port":2201,
                  "apache_version":"24",
                  "php_version":"70",
                  "start_servers":1,
                  "min_spare_servers":1,
                  "max_spare_servers":2,
                  "max_clients":4,
                  "type":"apache",
                  "action":"create"
              }
          )
      )
    end

    specify 'destroy action' do
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 2202, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site'),
                      system_group: create(:system_group, name: 'www'),
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'))
      expect(JSON.parse(apache.to_chef_json(:destroy))).to(
          match_json_expression(
              {
                  "user":"site",
                  "apache_version":"22",
                  "type":"apache",
                  "action":"destroy"
              }
          )
      )
    end

    specify 'destroy action with different apache variation' do
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 2203, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site'),
                      system_group: create(:system_group, name: 'www'),
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'))
      apache_variation = create(:apache_variation, apache_version: '2.4', php_version: '7.0', ip: '10.0.0.6')
      expect(JSON.parse(apache.to_chef_json(:destroy, apache_variation))).to(
          match_json_expression(
              {
                  "user":"site",
                  "apache_version":"24",
                  "type":"apache",
                  "action":"destroy"
              }
          )
      )
    end
  end
end
