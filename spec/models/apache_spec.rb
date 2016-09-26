require 'spec_helper'

describe Apache do
  it "should be valid" do
    build(:apache).should be_valid
  end

  it "should not be valid if port is too low" do
    expect(build(:apache, port: 4000)).not_to be_valid
  end

  it "should not be valid if port is too high" do
    expect(build(:apache, port: 65100)).not_to be_valid
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
    it 'should be 5000 if it is the first apache' do
      Apache.stubs(:maximum).returns(nil)
      apache = build(:apache)
      apache.set_defaults
      apache.port.should == 5000
    end

    it 'should be higher than maximum' do
      Apache.stubs(:maximum).returns(5005)
      apache = build(:apache)
      apache.set_defaults
      apache.port.should == 5006
    end
  end

  describe 'JSON for Chef' do
    before(:all) { @system_group = create(:system_group, name: 'nogroup') }

    specify 'create action' do
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 5200, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site1'),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'))
      expect(JSON.parse(apache.to_chef_json(:create))).to(
          match_json_expression(
              {
                  "server_admin":"admin@bosting.net",
                  "user":"site1",
                  "group":"nogroup",
                  "ip":"10.0.0.4",
                  "port":5200,
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
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 5201, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site2'),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'))
      apache_variation = create(:apache_variation, apache_version: '2.4', php_version: '7.0', ip: '10.0.0.6')
      expect(JSON.parse(apache.to_chef_json(:create, apache_variation))).to(
          match_json_expression(
              {
                  "server_admin":"admin@bosting.net",
                  "user":"site2",
                  "group":"nogroup",
                  "ip":"10.0.0.6",
                  "port":5201,
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
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 5202, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site3'),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'))
      expect(JSON.parse(apache.to_chef_json(:destroy))).to(
          match_json_expression(
              {
                  "user":"site3",
                  "apache_version":"22",
                  "type":"apache",
                  "action":"destroy"
              }
          )
      )
    end

    specify 'destroy action with different apache variation' do
      apache = create(:apache, server_admin: 'admin@bosting.net', port: 5203, start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site4'),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'))
      apache_variation = create(:apache_variation, apache_version: '2.4', php_version: '7.0', ip: '10.0.0.6')
      expect(JSON.parse(apache.to_chef_json(:destroy, apache_variation))).to(
          match_json_expression(
              {
                  "user":"site4",
                  "apache_version":"24",
                  "type":"apache",
                  "action":"destroy"
              }
          )
      )
    end
  end
end
