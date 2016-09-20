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

  attr_accessor :new_password
  before_save :hash_new_password

  def set_defaults(nologin = false)
    self.uid = [2000, 1 + SystemUser.maximum(:uid).to_i].max
    self.system_group = SystemGroup.find_by_name('webuser')
    self.system_user_shell = if nologin
                               SystemUserShell.get_nologin_shell
                             else
                               SystemUserShell.get_default_shell
                             end
  end

  def to_chef_json(action, apache_variation = nil)
    if action == :create
      system_user_hash = serializable_hash
      system_user_hash.keep_if do |key, value|
        %w(name uid hashed_password).include?(key)
      end
      system_user_hash['group'] = system_group.name
      system_user_hash['shell'] = system_user_shell.path
      system_user_hash['action'] = 'create'
      system_user_hash
    elsif action == :destroy
      { name: name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.merge('type' => 'system_user').to_json
  end

  private
  def hash_new_password
    self.hashed_password = new_password.crypt('$6$' + generate_random_password(16)) if new_password.present?
  end
end
