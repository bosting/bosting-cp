module CreateDnsRecordTypes
  def create_dns_record_types
    create(:dns_record_type, name: 'A')
    create(:dns_record_type, name: 'MX')
  end
end

if defined?(RSpec)
  RSpec.configure { |config| config.include CreateDnsRecordTypes }
end
