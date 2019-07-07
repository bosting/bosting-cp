module CreateSettings
  def create_settings
    create(:setting, name: 'default_mx', value: 'mx.example.com', value_type: 'string')
    create(:setting, name: 'directory_index', value: 'index.php index.phtml index.shtml index.html index.htm',
                     value_type: 'string')
    create(:setting, name: 'mysql_socket', value: '/tmp/mysql.sock', value_type: 'string')
    create(:setting, name: 'default_ns1', value: 'ns1.example.com', value_type: 'string')
    create(:setting, name: 'default_ns2', value: 'ns2.example.com', value_type: 'string')
    create(:setting, name: 'dir_mode', value: '00750', value_type: 'string')
  end
end

if defined?(RSpec)
  RSpec.configure { |config| config.include CreateSettings }
end
