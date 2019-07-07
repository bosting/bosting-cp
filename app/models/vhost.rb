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

  scope :active, -> { where(active: true) }

  def set_defaults
    self.primary = true if apache.vhosts.empty?
    self.directory_index = Setting.get('directory_index')
    self.ssl_port = 443
  end

  def name
    server_name
  end

  def to_chef(action, apache_variation = nil)
    apache_variation = apache.apache_variation if apache_variation.nil?
    apache_version = apache_variation.apache_version.sub('.', '')
    user = apache.system_user.name
    if action == :create
      {
        directory_index: directory_index,
        server_name: server_name,
        server_aliases: vhost_aliases.map(&:name),
        port: apache.port,
        apache_variation: apache_variation.name,
        show_indexes: indexes,
        user: user,
        group: apache.system_user.system_group.name,
        ip: apache_variation.ip,
        external_ip: apache.ip_address.ip,
        php_version: apache_variation.php_version.first,
        custom_config: custom_config.to_s
      }
    elsif action == :destroy
      { user: user, server_name: server_name }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end
      .merge(type: 'vhost', apache_version: apache_version, action: action.to_s)
  end
end
