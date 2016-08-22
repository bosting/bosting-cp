module DnsRecordsHelper
  def ip_address_value dns_record
    if dns_record.ip_address
      "#{dns_record.ip_address.name} [#{dns_record.ip_address.ip}]"
    else
      dns_record.value
    end
  end
end
