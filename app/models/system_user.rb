class SystemUser < ActiveRecord::Base
  include PasswordGenerator, CreateChefTask

  belongs_to :user
  belongs_to :system_group
  belongs_to :system_user_shell
  has_many :apaches
  has_many :ftps

  default_scope { order(:name) }

  validates :name, :uid, :user, :system_group, :system_user_shell, presence: true
  validates :name, :uid, uniqueness: true
  validates :uid, numericality: { greater_than_or_equal_to: Apache::MINIMUM_PORT, less_than_or_equal_to: Apache::MAXIMUM_PORT }

  attr_accessor :new_password
  before_save :hash_new_password

  def set_defaults(nologin = false)
    self.uid = [Apache::MINIMUM_PORT, 1 + SystemUser.maximum(:uid).to_i].max
    self.system_group = SystemGroup.find_by_name('webuser')
    self.system_user_shell = if nologin
                               SystemUserShell.get_nologin_shell
                             else
                               SystemUserShell.get_default_shell
                             end
  end

  def to_chef_json(action, apache_variation = nil)
    chroot_directory = if apache_variation.present?
                         ''
                       else
                         apache = Apache.where(system_user_id: id).first
                         if apache.present?
                           '/usr/jails/' + apache.apache_variation.name
                         else
                           ''
                         end
                       end
    if action == :create
      system_user_hash = serializable_hash.slice('name', 'uid', 'hashed_password')
      system_user_hash['group'] = system_group.name
      system_user_hash['shell'] = if apache_variation.present?
                                    '/sbin/nologin'
                                  else
                                    system_user_shell.path
                                  end
      system_user_hash['action'] = 'create'
      system_user_hash
    elsif action == :destroy
      { name: name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.merge('chroot_directory' => chroot_directory, 'type' => 'system_user').to_json
  end

  private

  def hash_new_password
    self.hashed_password = new_password.crypt('$6$' + generate_random_password(16)) if new_password.present?
  end
end
