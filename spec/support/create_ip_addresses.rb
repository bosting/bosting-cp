module CreateIpAddresses
  def create_ip_addresses
    create(:ip_address, name: 'ns1.hosting')
    create(:ip_address, name: 'ns2.hosting')
  end
end

RSpec.configure { |config| config.include CreateIpAddresses } if defined?(RSpec)
