class MysqlUser < ActiveRecord::Base
  include DbLoginValidation, CreateChefTask

  belongs_to :apache
  belongs_to :rails_server
  has_many :mysql_dbs, dependent: :destroy

  validates :login, presence: true, uniqueness: true, length: { maximum: 16 }

  attr_accessor :new_password, :create_db

  before_save :hash_new_password

  default_scope { order(:login) }

  def name
    login
  end

  def create_all_chef_tasks(action)
    case action
    when :create
      create_chef_task(:create)
      create_db_with_same_name if create_db == '1'
    when :destroy
      mysql_dbs.each { |mysql_db| mysql_db.create_chef_task(:destroy) }
      create_chef_task(:destroy)
    else
      raise ArgumentError, "Unknown task: #{action}"
    end
  end

  def to_chef(action)
    if action == :create
      {
        login: login,
        hashed_password: hashed_password,
        action: 'create'
      }
    elsif action == :destroy
      { login: login, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end
      .merge(type: 'mysql_user')
  end

  private

  def hash_new_password
    self.hashed_password = '*' + Digest::SHA1.hexdigest([Digest::SHA1.hexdigest(new_password)].pack('H*')).upcase if new_password.present?
  end

  def create_db_with_same_name
    mysql_db = mysql_dbs.create!(db_name: login)
    mysql_db.create_chef_task(:create)
  end
end
