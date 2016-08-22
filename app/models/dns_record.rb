class DnsRecord < ActiveRecord::Base
  belongs_to :domain
  belongs_to :dns_record_type
  belongs_to :ip_address

  after_save :set_updated
  before_destroy :set_updated

  validates :origin, :dns_record_type_id, presence: true

  attr_accessor :skip_set_updated

  def name
    self.origin
  end

  protected
  def set_updated
    domain.update_attribute(:updated, true) if !skip_set_updated and domain.active?
  end
end
