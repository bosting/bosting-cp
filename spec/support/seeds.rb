RSpec.configure do |config|
  config.before(:all) do
    Setting.create!(name: 'default_ns1', value: 'ns1.hosting', value_type: 'string')
    Setting.create!(name: 'default_ns2', value: 'ns2.hosting', value_type: 'string')
    Setting.create!(name: 'directory_index', value: 'index.php', value_type: 'string')
    Setting.create!(name: 'mysql_socket', value: '/tmp/mysql.sock', value_type: 'string')
    Setting.create!(name: 'server_domain', value: 'hosting', value_type: 'string')
  end
end
