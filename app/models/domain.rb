class Domain < ActiveRecord::Base
  attr_accessor :add_default_records, :add_default_mx_records, :add_gmail_mx_records

  belongs_to :user
  has_many :dns_records, dependent: :destroy
  belongs_to :ns1_ip_address, class_name: 'IpAddress', foreign_key: :ns1_ip_address_id
  belongs_to :ns2_ip_address, class_name: 'IpAddress', foreign_key: :ns2_ip_address_id

  default_scope { order(:name) }
  scope :active, -> { where(active: true) }

  validates :name, :email, :ns1_ip_address_id, :ns2_ip_address_id, presence: true
  validates :name, uniqueness: true

  before_save :set_serial
  after_save :do_add_default_records, :do_add_default_mx_records, :do_add_gmail_mx_records

  def set_defaults
    self.email = "hostmaster@#{Setting.get('server_domain')}"
  end

  def self.ensure_dot(domain_name)
    if domain_name.match(/\.$/).nil?
      domain_name + '.'
    else
      domain_name
    end
  end

  private

  def set_serial
    now = Time.now
    new_serial = Time.new.strftime('%Y%m%d' + (4 * now.hour + now.min / 15).to_s)
    new_serial = ([new_serial.to_i, serial.to_i].max + 1).to_s if serial.to_i >= new_serial.to_i
    self.serial = new_serial
  end

  def do_add_default_records
    return if add_default_records != '1'
    type_a = DnsRecordType.find_a
    www_server_ip = IpAddress.find_by(name: Setting.get('server_domain'))
    dns_records.create!(origin: '@', dns_record_type: type_a,
                        ip_address: www_server_ip)
    dns_records.create!(origin: 'www', dns_record_type: type_a,
                        ip_address: www_server_ip)
  end

  def do_add_default_mx_records
    return if add_default_mx_records != '1'
    type_mx = DnsRecordType.find_mx
    value = Domain.ensure_dot(Setting.get('default_mx'))
    dns_records.create!(origin: '@', dns_record_type: type_mx, value: value,
                        mx_priority: 10)
  end

  def do_add_gmail_mx_records
    return if add_gmail_mx_records != '1'
    type_mx = DnsRecordType.find_mx
    [
      %w(aspmx.l.google.com. 1),
      %w(alt1.aspmx.l.google.com. 5),
      %w(alt2.aspmx.l.google.com. 5),
      %w(alt3.aspmx.l.google.com. 10),
      %w(alt4.aspmx.l.google.com. 10)
    ].each do |value, mx_priority|
      dns_records.create!(origin: '@', dns_record_type: type_mx, value: value,
                          mx_priority: mx_priority)
    end
  end
end
