class Apache < ActiveRecord::Base
  include CreateChefTask

  MINIMUM_PORT = 5000
  MAXIMUM_PORT = 65000

  belongs_to :user
  belongs_to :system_user
  belongs_to :system_group
  belongs_to :ip_address
  belongs_to :apache_variation
  has_many :vhosts, dependent: :delete_all
  has_many :mysql_users
  has_many :pgsql_users

  validates :user, :system_user, :system_group, :ip_address, :port, :min_spare_servers, :max_spare_servers,
            :start_servers, :max_clients, :server_admin, :apache_variation, presence: true
  validates :port, :system_user_id, uniqueness: true
  validates :port, numericality: { greater_than_or_equal_to: MINIMUM_PORT, less_than_or_equal_to: MAXIMUM_PORT }

  scope :active, -> { uniq.joins(:vhosts).where(active: true, vhosts: { active: true }) }
  scope :ordered, -> { joins(:system_user).order('`system_users`.`name` ASC') }
  scope :find_domain, ->(*name) do
    name = name.first
    if name.to_s.strip != ""
      name = "%#{name}%"
      joins('LEFT OUTER JOIN `vhosts` ON `vhosts`.`apache_id` = `apaches`.`id`').
      joins('LEFT OUTER JOIN `vhost_aliases` ON `vhost_aliases`.`vhost_id` = `vhosts`.`id`').
      where("`vhosts`.`server_name` LIKE ? OR `vhost_aliases`.`name` LIKE ?", name, name).uniq
    end
  end

  def self.search options
    select('`apaches`.`id`, `apaches`.`active`, `system_users`.`name` AS `system_user_name`, `apache_variations`.`description` AS `apache_variation_name`').
        joins('LEFT OUTER JOIN `system_users` ON `apaches`.`system_user_id` = `system_users`.`id`').
        joins('LEFT OUTER JOIN `apache_variations` ON `apaches`.`apache_variation_id` = `apache_variations`.`id`').
        order('`system_user_name`').find_domain(options[:domain])
  end

  def name
    system_user.try(:name)
  end

  def set_defaults
    self.system_group = SystemGroup.find_by_name('nogroup')
    self.port = [MINIMUM_PORT, 1 + Apache.maximum(:port).to_i].max
    self.min_spare_servers = 1
    self.max_spare_servers = 1
    self.start_servers = 1
    self.max_clients = 4
    self.server_admin = "webmaster@#{Setting.get('server_domain')}"
  end

  def all_server_names
    vhosts.active.inject([]) do |arr, v|
      arr << v.server_name
      arr << v.vhost_aliases.map(&:name)
      arr
    end
  end

  def to_chef_json(action, apache_variation = nil)
    apache_variation = self.apache_variation if apache_variation.nil?
    system_user_name = system_user.name
    apache_version = apache_variation.apache_version.sub('.', '')
    if action == :create
      apache_hash = serializable_hash
      apache_hash.keep_if do |key, value|
        %w(server_admin port min_spare_servers max_spare_servers start_servers max_clients).include?(key)
      end
      apache_hash['user'] = system_user_name
      apache_hash['group'] = system_group.name
      apache_hash['ip'] = apache_variation.ip
      apache_hash['php_version'] = apache_variation.php_version.sub('.', '')
      apache_hash['action'] = 'create'
      apache_hash
    elsif action == :destroy
      { user: system_user_name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.merge('type' => 'apache', 'apache_version' => apache_version).to_json
  end

  def create_crontab_migration
    av_change = previous_changes[:apache_variation_id]
    if av_change.present?
      cm = CrontabMigration.new(
          system_user.name,
          ApacheVariation.find(av_change.first).name,
          ApacheVariation.find(av_change.last).name)
      cm.create_chef_task(:move)
    end
  end
end
