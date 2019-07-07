# frozen_string_literal: true

require 'spec_helper'

describe Vhost do
  it 'should be valid' do
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

  describe '#to_chef' do
    let(:webuser_group) { create(:system_group, name: 'webuser') }
    let(:nogroup) { create(:system_group, name: 'nogroup') }
    let(:system_user) { create(:system_user, name: 'site', system_group: webuser_group, uid: 5_200) }
    let(:ip_address) { create(:ip_address, ip: '10.37.132.10') }
    let(:apache_variation) do
      create(:apache_variation, name: 'apache22_php55', apache_version: '2.2', php_version: '5.5', ip: '10.0.0.4')
    end

    subject { vhost.to_chef(action) }

    describe 'create action' do
      let(:action) { :create }
      let(:apache) do
        create(:apache, server_admin: 'admin@bosting.net', start_servers: 1, min_spare_servers: 1,
                        max_spare_servers: 2, max_clients: 4, system_user: system_user,
                        system_group: nogroup, ip_address: ip_address, apache_variation: apache_variation)
      end
      let(:vhost) do
        create(:vhost, apache: apache, server_name: 'site.com', primary: true,
                       directory_index: 'index.php index.html index.htm',
                       indexes: false, vhost_aliases: [
                         create(:vhost_alias, name: 'www.site.com'),
                         create(:vhost_alias, name: 'www2.site.com')
                       ])
      end
      let(:result_hash) do
        {
          server_name: 'site.com',
          ip: '10.0.0.4',
          external_ip: '10.37.132.10',
          port: 5_200,
          apache_variation: 'apache22_php55',
          user: 'site',
          group: 'webuser',
          server_aliases: %w[www.site.com www2.site.com],
          directory_index: 'index.php index.html index.htm',
          apache_version: '22',
          php_version: '5',
          show_indexes: false,
          type: 'vhost',
          action: 'create'
        }
      end

      it { is_expected.to match(result_hash) }
    end

    specify 'create action with different apache variation' do
      vhost = create(:vhost, server_name: 'www3.site.com', primary: true,
                             directory_index: 'index.php index.html index.htm',
                             indexes: false, vhost_aliases:
                       [create(:vhost_alias, name: 'www4.site.com'),
                        create(:vhost_alias, name: 'www5.site.com')])
      create(:apache, server_admin: 'admin@bosting.net', start_servers: 1,
                      min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: system_user,
                      system_group: nogroup,
                      ip_address: ip_address,
                      apache_variation: apache_variation,
                      vhosts: [vhost])
      apache_variation = create(:apache_variation, name: 'apache24_php70',
                                                   apache_version: '2.4', php_version: '7.0',
                                                   ip: '10.0.0.6')
      expect(vhost.to_chef(:create, apache_variation)).to(
        match(
          server_name: 'www3.site.com',
          ip: '10.0.0.6',
          external_ip: '10.37.132.10',
          port: 5_200,
          apache_variation: 'apache24_php70',
          user: 'site',
          group: 'webuser',
          server_aliases: %w[www4.site.com www5.site.com],
          directory_index: 'index.php index.html index.htm',
          apache_version: '24',
          php_version: '7',
          show_indexes: false,
          type: 'vhost',
          action: 'create'
        )
      )
    end

    specify 'destroy action' do
      vhost = create(:vhost, server_name: 'www6.site.com', primary: true,
                             directory_index: 'index.php index.html index.htm',
                             indexes: false, vhost_aliases:
                       [create(:vhost_alias, name: 'www7.site.com'),
                        create(:vhost_alias, name: 'www8.site.com')])
      create(:apache, server_admin: 'admin@bosting.net', start_servers: 1,
                      min_spare_servers: 1, max_spare_servers: 2, max_clients: 4,
                      system_user: system_user,
                      system_group: nogroup,
                      ip_address: ip_address,
                      apache_variation: apache_variation,
                      vhosts: [vhost])
      expect(vhost.to_chef(:destroy)).to(
        match(
          server_name: 'www6.site.com',
          user: 'site',
          apache_version: '22',
          type: 'vhost',
          action: 'destroy'
        )
      )
    end

    specify 'destroy action with different apache variation' do
      vhost = create(:vhost, server_name: 'www9.site.com', primary: true,
                             directory_index: 'index.php index.html index.htm',
                             indexes: false, vhost_aliases:
                       [create(:vhost_alias, name: 'www10.site.com'),
                        create(:vhost_alias, name: 'www11.site.com')])
      create(:apache, server_admin: 'admin@bosting.net', start_servers: 1, min_spare_servers: 1, max_spare_servers: 2,
                      max_clients: 4,
                      system_user: system_user,
                      system_group: nogroup,
                      ip_address: ip_address,
                      apache_variation: apache_variation,
                      vhosts: [vhost])
      apache_variation = create(:apache_variation, apache_version: '2.4', php_version: '7.0', ip: '10.0.0.6')
      expect(vhost.to_chef(:destroy, apache_variation)).to(
        match(
          server_name: 'www9.site.com',
          user: 'site',
          apache_version: '24',
          type: 'vhost',
          action: 'destroy'
        )
      )
    end
  end
end
