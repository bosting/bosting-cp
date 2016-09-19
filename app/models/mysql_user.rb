class MysqlUser < ActiveRecord::Base
  include DbLoginValidation, CreateChefTask

  belongs_to :apache
  belongs_to :rails_server
  has_many :mysql_dbs

  validates :login, presence: true, uniqueness: true

  attr_accessor :new_password, :create_db

  before_save :hash_new_password
  after_save :do_create_db

  default_scope { order(:login) }
  scope :not_deleted, -> { where(is_deleted: false) }

  def destroy
    update_attribute :is_deleted, true
    mysql_dbs.update_all is_deleted: true
  end

  def name
    self.login
  end

  def to_chef_json(action)
    if action == :create
      mysql_user_hash = serializable_hash
      mysql_user_hash.keep_if do |key, value|
        %w(login hashed_password).include?(key)
      end
      mysql_user_hash['action'] = 'create'
      mysql_user_hash
    elsif action == :destroy
      { login: login, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.merge('type' => 'mysql_user').to_json
  end

  private
  def hash_new_password
    self.hashed_password = '*' + Digest::SHA1.hexdigest([Digest::SHA1.hexdigest(new_password)].pack("H*")).upcase if new_password
  end

  def do_create_db
    if create_db
      mysql_dbs.create(db_name: login)
    end
  end
end
