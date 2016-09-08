require 'spec_helper'

describe Vhost do
  it "should be valid" do
    build(:vhost).should be_valid
  end

  context 'SSL on' do
    it 'should not be valid' do
      build(:vhost, ssl: true).should_not be_valid
    end

    it 'should not be valid' do
      build(:vhost_ssl).should be_valid
    end

    describe 'port uniqueness' do
      before(:all) { @ip_address = create(:ip_address) }

      it 'should be valid' do
        create(:vhost_ssl, ssl_port: 443, ssl_ip_address: @ip_address).should be_valid
        create(:vhost_ssl, ssl_port: 444, ssl_ip_address: @ip_address).should be_valid
        build(:vhost_ssl, ssl_port: 443, ssl_ip_address: create(:ip_address)).should be_valid
      end

      it 'should not be valid' do
        create(:vhost_ssl, ssl_port: 8443, ssl_ip_address: @ip_address).should be_valid
        build(:vhost_ssl, ssl_port: 8443, ssl_ip_address: @ip_address).should_not be_valid
      end
    end
  end

  describe 'JSON for Chef' do
    specify 'create action' do
      vhost = create(:vhost, server_name: 'site.com', primary: true,
                     directory_index: 'index.php index.html index.htm', indexes: false, vhost_aliases:
                         [create(:vhost_alias, name: 'www.site.com'), create(:vhost_alias, name: 'www2.site.com')])
      create(:apache, server_admin: 'admin@bosting.net', port: 2200, start_servers: 1, min_spare_servers: 1,
             max_spare_servers: 2, max_clients: 4,
             system_user: create(:system_user, name: 'site'),
             system_group: create(:system_group, name: 'www'),
             ip_address: create(:ip_address, ip: '10.37.132.10'),
             apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'),
             vhosts: [vhost])
      expect(JSON.parse(vhost.to_chef_json(:create))).to(
          match_json_expression(
              {
                  "server_name":"site.com",
                  "ip":"10.0.0.4",
                  "port":2200,
                  "user":"site",
                  "group":"www",
                  "server_alias":"www.site.com www2.site.com",
                  "directory_index":"index.php index.html index.htm",
                  "apache_version":"22",
                  "php_version":"5",
                  "show_indexes":false,
                  "type":"vhost",
                  "action":"create"
              }
          )
      )
    end

    specify 'create action with different apache variation' do
      vhost = create(:vhost, server_name: 'www3.site.com', primary: true,
                     directory_index: 'index.php index.html index.htm', indexes: false, vhost_aliases:
                         [create(:vhost_alias, name: 'www4.site.com'), create(:vhost_alias, name: 'www5.site.com')])
      create(:apache, server_admin: 'admin@bosting.net', port: 2201, start_servers: 1, min_spare_servers: 1,
             max_spare_servers: 2, max_clients: 4,
             system_user: create(:system_user, name: 'site2'),
             system_group: create(:system_group, name: 'www'),
             ip_address: create(:ip_address, ip: '10.37.132.10'),
             apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'),
             vhosts: [vhost])
      apache_variation = create(:apache_variation, apache_version: '2.4', php_version: '7.0', ip: '10.0.0.6')
      expect(JSON.parse(vhost.to_chef_json(:create, apache_variation))).to(
          match_json_expression(
              {
                  "server_name":"www3.site.com",
                  "ip":"10.0.0.6",
                  "port":2201,
                  "user":"site2",
                  "group":"www",
                  "server_alias":"www4.site.com www5.site.com",
                  "directory_index":"index.php index.html index.htm",
                  "apache_version":"24",
                  "php_version":"7",
                  "show_indexes":false,
                  "type":"vhost",
                  "action":"create"
              }
          )
      )
    end

    specify 'destroy action' do
      vhost = create(:vhost, server_name: 'www6.site.com', primary: true,
                     directory_index: 'index.php index.html index.htm', indexes: false, vhost_aliases:
                         [create(:vhost_alias, name: 'www7.site.com'), create(:vhost_alias, name: 'www8.site.com')])
      create(:apache, server_admin: 'admin@bosting.net', port: 2202, start_servers: 1, min_spare_servers: 1,
             max_spare_servers: 2, max_clients: 4,
             system_user: create(:system_user, name: 'site3'),
             system_group: create(:system_group, name: 'www'),
             ip_address: create(:ip_address, ip: '10.37.132.10'),
             apache_variation: create(:apache_variation, apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4'),
             vhosts: [vhost])
      expect(JSON.parse(vhost.to_chef_json(:destroy))).to(
          match_json_expression(
              {
                  "server_name":"www6.site.com",
                  "user":"site3",
                  "type":"vhost",
                  "action":"destroy"
              }
          )
      )
    end
  end
end
