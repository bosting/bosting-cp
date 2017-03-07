class IpAddress < ActiveRecord::Base
  include SimplePosition
  default_scope { order(:position) }

  validates :name, :ip, presence: true
  validates :name, :position, uniqueness: true

  def to_label
    name + " [#{ip}]"
  end

  def self.get_default_apache_ip_id
    where(is_default: true).pluck(:id).first
  end

  def self.get_default_ns1_ip_id
    select(:id).find_by(name: Setting.get('default_ns1')).id
  end

  def self.get_default_ns2_ip_id
    select(:id).find_by(name: Setting.get('default_ns2')).id
  end

  def self.get_collection
    select([:id, :name, :ip]).map { |ip| [ip.to_label, ip.id] }
  end
end
