class Vhost < ActiveRecord::Base
  include CreateChefTask

  belongs_to :apache
  has_many :vhost_aliases, dependent: :delete_all
  belongs_to :ssl_cert_chain
  belongs_to :ssl_ip_address, class_name: IpAddress

  accepts_nested_attributes_for :vhost_aliases, allow_destroy: true

  validates :server_name, :directory_index, presence: true
  validates :server_name, uniqueness: true
  validates :ssl_port, uniqueness: { scope: :ssl_ip_address_id }, if: :ssl
  validates :ssl_ip_address, :ssl_port, :ssl_key, :ssl_certificate, presence: true, if: :ssl

  before_save :set_updated
  before_destroy :set_updated

  scope :active, -> { where(active: true, is_deleted: false) }
  scope :not_deleted, -> { where(is_deleted: false) }
  scope :is_deleted, -> { where(is_deleted: true) }

  def set_defaults
    if self.apache.vhosts.size == 0
      self.primary = true
    end
    self.directory_index = Setting.get('directory_index')
    self.ssl_port = 443
  end

  def name
    self.server_name
  end

  def destroy
    update_attribute :is_deleted, true
  end

  def to_chef_json(action, apache_variation = nil)
    apache_variation = self.apache.apache_variation if apache_variation.nil?
    user = apache.system_user.name
    if action == :create
      vhost_hash = serializable_hash
      vhost_hash.keep_if do |key, value|
        %w(directory_index).include?(key)
      end
      vhost_hash['server_name'] = server_name
      vhost_hash['server_aliases'] = vhost_aliases.map(&:name)
      vhost_hash['port'] = apache.port
      vhost_hash['show_indexes'] = indexes
      vhost_hash['user'] = user
      vhost_hash['group'] = apache.system_group.name
      vhost_hash['ip'] = apache_variation.ip
      vhost_hash['apache_version'] = apache_variation.apache_version.sub('.', '')
      vhost_hash['php_version'] = apache_variation.php_version[0]
      vhost_hash['action'] = 'create'
      vhost_hash
    elsif action == :destroy
      { user: user, server_name: server_name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.merge('type' => 'vhost').to_json
  end

  protected
  def set_updated
    apache.update_attribute(:updated, true) if apache.active?
  end
end
