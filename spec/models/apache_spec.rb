require 'spec_helper'

describe Apache do
  it 'should be valid' do
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

  describe '#to_chef' do
    before(:all) { @system_group = create(:system_group, name: 'nogroup') }

    specify 'create action' do
      apache = create(:apache, server_admin: 'admin@bosting.net',
                      start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site1',
                                          uid: 5_200),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation:
                        create(:apache_variation, apache_version: '2.2',
                               php_version: '5.5', ip: '10.0.0.4'))
      expect(apache.to_chef(:create)).to(
        match(
          server_admin: 'admin@bosting.net',
          user: 'site1',
          group: 'nogroup',
          ip: '10.0.0.4',
          port: 5_200,
          apache_version: '22',
          php_version: '55',
          start_servers: 1,
          min_spare_servers: 1,
          max_spare_servers: 2,
          max_clients: 4,
          type: 'apache',
          action: 'create'
        )
      )
    end

    specify 'create action with same apache variation' do
      apache_variation = create(:apache_variation, apache_version: '2.2',
                                php_version: '5.5', ip: '10.0.0.4')
      apache = create(:apache, server_admin: 'admin@bosting.net',
                      start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site2',
                                          uid: 5_201),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation: apache_variation)
      expect(apache.to_chef(:create, apache_variation)).to(
        match(
          server_admin: 'admin@bosting.net',
          user: 'site2',
          group: 'nogroup',
          ip: '10.0.0.4',
          port: 5_201,
          apache_version: '22',
          php_version: '55',
          start_servers: 1,
          min_spare_servers: 1,
          max_spare_servers: 2,
          max_clients: 4,
          type: 'apache',
          action: 'create'
        )
      )
    end

    specify 'create action with different apache variation' do
      apache = create(:apache, server_admin: 'admin@bosting.net',
                      start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site3',
                                          uid: 5_202),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation:
                        create(:apache_variation, apache_version: '2.2',
                               php_version: '5.5', ip: '10.0.0.4'))
      apache_variation = create(:apache_variation, apache_version: '2.4',
                                php_version: '7.0', ip: '10.0.0.6')
      expect(apache.to_chef(:create, apache_variation)).to(
        match(
          server_admin: 'admin@bosting.net',
          user: 'site3',
          group: 'nogroup',
          ip: '10.0.0.6',
          port: 5_202,
          apache_version: '24',
          php_version: '70',
          start_servers: 1,
          min_spare_servers: 1,
          max_spare_servers: 2,
          max_clients: 4,
          type: 'apache',
          action: 'stop'
        )
      )
    end

    specify 'destroy action' do
      apache = create(:apache, server_admin: 'admin@bosting.net',
                      start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site4',
                                          uid: 5_203),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation:
                        create(:apache_variation, apache_version: '2.2',
                               php_version: '5.5', ip: '10.0.0.4'))
      expect(apache.to_chef(:destroy)).to(
        match(
          user: 'site4',
          apache_version: '22',
          type: 'apache',
          action: 'destroy'
        )
      )
    end

    specify 'destroy action with different apache variation' do
      apache = create(:apache, server_admin: 'admin@bosting.net',
                      start_servers: 1, min_spare_servers: 1,
                      max_spare_servers: 2, max_clients: 4,
                      system_user: create(:system_user, name: 'site5',
                                          uid: 5_204),
                      system_group: @system_group,
                      ip_address: create(:ip_address, ip: '10.37.132.10'),
                      apache_variation:
                        create(:apache_variation, apache_version: '2.2',
                               php_version: '5.5', ip: '10.0.0.4'))
      apache_variation = create(:apache_variation, apache_version: '2.4',
                                php_version: '7.0', ip: '10.0.0.6')
      expect(apache.to_chef(:destroy, apache_variation)).to(
        match(
          user: 'site5',
          apache_version: '24',
          type: 'apache',
          action: 'destroy'
        )
      )
    end
  end
end
