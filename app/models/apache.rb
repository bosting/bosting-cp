class Apache < ActiveRecord::Base
  include CreateChefTask

  belongs_to :user
  belongs_to :system_user
  belongs_to :system_group
  belongs_to :ip_address
  belongs_to :apache_variation
  has_many :vhosts, dependent: :delete_all
  has_many :mysql_users
  has_many :pgsql_users

  validates :user, :system_user, :system_group, :ip_address, :min_spare_servers, :max_spare_servers,
            :start_servers, :max_clients, :server_admin, :apache_variation, presence: true
  validates :system_user_id, uniqueness: true

  scope :active, -> { uniq.joins(:vhosts).where(active: true, vhosts: { active: true }) }
  scope :ordered, -> { joins(:system_user).order('`system_users`.`name` ASC') }
  scope(:find_domain, lambda do |*name|
    name = name.first
    return if name.blank?
    name = "%#{name}%"
    joins('LEFT OUTER JOIN `vhosts` ON `vhosts`.`apache_id` = `apaches`.`id`')
      .joins('LEFT OUTER JOIN `vhost_aliases` ON `vhost_aliases`.`vhost_id` = `vhosts`.`id`')
      .where('`vhosts`.`server_name` LIKE ? OR `vhost_aliases`.`name` LIKE ?', name, name).uniq
  end)

  def self.search(options)
    select('`apaches`.`id`, `apaches`.`active`, `system_users`.`name` AS `system_user_name`, `apache_variations`.`description` AS `apache_variation_name`')
      .joins('LEFT OUTER JOIN `system_users` ON `apaches`.`system_user_id` = `system_users`.`id`')
      .joins('LEFT OUTER JOIN `apache_variations` ON `apaches`.`apache_variation_id` = `apache_variations`.`id`')
      .order('`system_user_name`').find_domain(options[:domain])
  end

  def name
    system_user.try(:name)
  end

  def set_defaults
    self.system_group = SystemGroup.find_nogroup
    self.min_spare_servers = 1
    self.max_spare_servers = 1
    self.start_servers = 1
    self.max_clients = 4
    self.server_admin = "webmaster@#{Setting.get('server_domain')}"
  end

  def all_server_names
    vhosts.active.each_with_object([]) do |v, arr|
      arr << v.server_name
      arr << v.vhost_aliases.map(&:name)
      arr
    end
  end

  def to_chef(action, apache_variation = nil)
    apache_variation = self.apache_variation if apache_variation.nil?
    system_user_name = system_user.name
    apache_version = apache_variation.apache_version.sub('.', '')
    case action
    when :create
      action = if apache_variation == self.apache_variation
                 'create'
               else
                 'stop'
               end
      {
        server_admin: server_admin,
        min_spare_servers: min_spare_servers,
        max_spare_servers: max_spare_servers,
        start_servers: start_servers,
        max_clients: max_clients,
        user: system_user_name,
        group: system_group.name,
        ip: apache_variation.ip,
        php_version: apache_variation.php_version.sub('.', ''),
        action: action,
        port: port,
        custom_config: custom_config.to_s
      }
    when :destroy
      { user: system_user_name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end
      .merge(type: 'apache', apache_version: apache_version)
  end

  def create_all_chef_tasks(is_update_action)
    create_chef_task(:create)
    av_change = previous_changes[:apache_variation_id]
    return if av_change.blank?
    create_dependent_tasks
    return unless is_update_action
    create_crontab_migration(av_change.first, av_change.last)
  end

  def port
    system_user.uid
  end

  private

  def create_dependent_tasks
    system_user.create_chef_task(:create)
    vhosts.each { |vhost| vhost.create_chef_task(:create) }
  end

  def create_crontab_migration(av_old_id, av_new_id)
    cm = CrontabMigration.new(
      system_user.name,
      ApacheVariation.find(av_old_id).name,
      ApacheVariation.find(av_new_id).name
    )
    cm.create_chef_task(:move)
  end
end
