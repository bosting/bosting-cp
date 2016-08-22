class PgsqlUser < ActiveRecord::Base
  include DbLoginValidation

  belongs_to :apache
  belongs_to :rails_server
  has_many :pgsql_dbs

  validates :login, presence: true, uniqueness: true

  attr_accessor :new_password, :create_db

  before_save :hash_new_password
  after_save :do_create_db

  default_scope { order(:login) }
  scope :not_deleted, -> { where(is_deleted: false) }

  def destroy
    update_attribute :is_deleted, true
    pgsql_dbs.update_all is_deleted: true
  end

  def name
    self.login
  end

  private
  def hash_new_password
    self.hashed_password = 'md5' + Digest::MD5.hexdigest(new_password + login) if new_password
  end

  def do_create_db
    if create_db
      pgsql_dbs.create(db_name: login)
    end
  end
end
