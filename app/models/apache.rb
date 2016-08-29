class Apache < ActiveRecord::Base
  include CreateChefTask

  belongs_to :user
  belongs_to :system_user
  belongs_to :system_group
  belongs_to :ip_address
  belongs_to :apache_variation
  belongs_to :apache_variation_prev, class_name: 'ApacheVariation'
  has_many :vhosts, dependent: :delete_all
  has_many :mysql_users
  has_many :pgsql_users

  validates :user, :system_user, :system_group, :ip_address, :port, :min_spare_servers, :max_spare_servers,
            :start_servers, :max_clients, :server_admin, :apache_variation, presence: true
  validates :port, :system_user_id, uniqueness: true

  attr_accessor :destroy_user, :destroy_ftps, :destroy_system_user,
                :destroy_mysql_users, :destroy_pgsql_users, :destroy_domains

  before_save :set_updated, :set_av_changed

  scope :active, -> { uniq.joins(:vhosts).where(active: true, is_deleted: false, vhosts: { active: true, is_deleted: false }) }
  scope :not_deleted, -> { where(is_deleted: false) }
  scope :is_deleted, -> { where(is_deleted: true) }
  scope :ordered, -> { joins(:system_user).order('`system_users`.`name` ASC') }
  scope :updated, -> { where(updated: true) }
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
    select('`apaches`.`id`, `apaches`.`active`, `apaches`.`updated`, `system_users`.`name` AS `system_user_name`, `apache_variations`.`description` AS `apache_variation_name`').
        joins('LEFT OUTER JOIN `system_users` ON `apaches`.`system_user_id` = `system_users`.`id`').
        joins('LEFT OUTER JOIN `apache_variations` ON `apaches`.`apache_variation_id` = `apache_variations`.`id`').
        not_deleted.order('`system_user_name`').find_domain(options[:domain])
  end

  def name
    system_user.try(:name)
  end

  def set_defaults
    self.system_group = SystemGroup.find_by_name('nogroup')
    self.port = 1 + Apache.maximum(:port).to_i
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

  def destroy
    create_chef_task(:destroy)
    user.domains.each(&:destroy) if destroy_domains == '1'
    user.destroy if destroy_user == '1'
    system_user.ftps.each(&:destroy) if destroy_ftps == '1'
    system_user.destroy if destroy_system_user == '1'
    mysql_users.each(&:destroy) if destroy_mysql_users == '1'
    pgsql_users.each(&:destroy) if destroy_pgsql_users == '1'
    update_attribute :is_deleted, true
    vhosts.update_all is_deleted: true
  end

  def to_chef_json(action)
    system_user_name = system_user.name
    if action == :create
      apache_hash = serializable_hash
      apache_hash.keep_if do |key, value|
        %w(server_admin port min_spare_servers max_spare_servers start_servers max_clients).include?(key)
      end
      apache_hash['user'] = system_user_name
      apache_hash['group'] = system_group.name
      apache_hash['ip'] = ip_address.ip
      apache_hash['apache_version'] = apache_variation.apache_version.sub('.', '')
      apache_hash['php_version'] = apache_variation.php_version.sub('.', '')
      apache_hash['action'] = ['create', 'enable', 'start', 'reload']
      apache_hash
    elsif action == :destroy
      { user: system_user_name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.to_json
  end

  protected
  def set_updated
    self.updated = true if active?
  end

  def set_av_changed
    if apache_variation_id_changed? and !new_record?
      self.av_changed = true
      self.apache_variation_prev_id = apache_variation_id_was
    end
  end
end
