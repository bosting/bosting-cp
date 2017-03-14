class DnsRecordType < ActiveRecord::Base
  include SimplePosition
  default_scope { order(:position) }

  def self.find_a
    @record_a ||= DnsRecordType.find_by(name: 'A')
  end

  def self.find_mx
    @record_mx ||= DnsRecordType.find_by(name: 'MX')
  end
end
