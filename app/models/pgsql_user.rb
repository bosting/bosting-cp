class PgsqlUser < ActiveRecord::Base
  include DbLoginValidation, CreateChefTask

  belongs_to :apache
  belongs_to :rails_server
  has_many :pgsql_dbs

  validates :login, presence: true, uniqueness: true

  attr_accessor :new_password, :create_db

  before_save :hash_new_password
  after_save :do_create_db

  default_scope { order(:login) }

  def name
    self.login
  end

  def to_chef_json(action)
    if action == :create
      pgsql_user_hash = serializable_hash
      pgsql_user_hash.keep_if do |key, value|
        %w(login hashed_password).include?(key)
      end
      pgsql_user_hash['action'] = 'create'
      pgsql_user_hash
    elsif action == :destroy
      { login: login, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.merge('type' => 'pgsql_user').to_json
  end

  private
  def hash_new_password
    self.hashed_password = 'md5' + Digest::MD5.hexdigest(new_password + login) if new_password.present?
  end

  def do_create_db
    if create_db
      pgsql_db = pgsql_dbs.create!(db_name: login)
      pgsql_db.create_chef_task(:create)
    end
  end
end
