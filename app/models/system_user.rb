class SystemUser < ActiveRecord::Base
  include PasswordGenerator, CreateChefTask

  MINIMUM_UID = 5_000
  MAXIMUM_UID = 65_000

  belongs_to :user
  belongs_to :system_group
  belongs_to :system_user_shell
  has_many :apaches
  has_many :ftps

  default_scope { order(:name) }

  validates :name, :uid, :user, :system_group, :system_user_shell,
            presence: true
  validates :name, :uid, uniqueness: true
  validates :uid, numericality: { greater_than_or_equal_to: MINIMUM_UID,
                                  less_than_or_equal_to: MAXIMUM_UID }
  validates :uid, uniqueness: true

  attr_accessor :new_password
  before_save :hash_new_password

  def self.build_with_ssh(options)
    system_user = SystemUser.build_object(options)
    system_user.system_user_shell = SystemUserShell.default_shell
    system_user
  end

  def self.build_without_ssh(options)
    system_user = SystemUser.build_object(options)
    system_user.system_user_shell = SystemUserShell.nologin_shell
    system_user
  end

  def self.build_object(options)
    system_user = SystemUser.new(name: options[:login], user: options[:user],
                                 new_password: options[:ssh_password])
    system_user.set_defaults
    system_user
  end

  def set_defaults
    self.uid = next_uid
    self.system_group = SystemGroup.find_webuser
  end

  def next_uid
    max_uid = SystemUser.maximum(:uid).to_i
    [MINIMUM_UID, max_uid + 1].max
  end

  def to_chef_json(action, apache_variation = nil)
    hash = chef_hash(action, apache_variation)
    hash['type'] = 'system_user'
    hash['chroot_directory'] = chroot_directory(apache_variation)
    hash.to_json
  end

  private

  def chef_hash(action, apache_variation)
    case action
    when :create
      chef_hash_for_create(apache_variation)
    when :destroy
      { name: name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end
  end

  def chef_hash_for_create(apache_variation)
    hash = serializable_hash.slice('name', 'uid', 'hashed_password')
    hash['group'] = system_group.name
    hash['shell'] = if apache_variation.present?
                      '/sbin/nologin'
                    else
                      system_user_shell.path
                    end
    hash['action'] = 'create'
    hash
  end

  def chroot_directory(apache_variation)
    return '' if apache_variation.present?
    apache = Apache.where(system_user_id: id).first
    return '' if apache.blank?
    '/usr/jails/' + apache.apache_variation.name
  end

  def hash_new_password
    return if new_password.blank?
    self.hashed_password =
      new_password.crypt('$6$' + generate_random_password(16))
  end
end
