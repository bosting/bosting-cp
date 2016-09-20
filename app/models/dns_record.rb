class DnsRecord < ActiveRecord::Base
  belongs_to :domain
  belongs_to :dns_record_type
  belongs_to :ip_address

  validates :origin, :dns_record_type_id, presence: true

  def name
    self.origin
  end
end
