class Ftp < ActiveRecord::Base
  self.table_name = 'pureftpd'

  belongs_to :system_user

  attr_accessor :new_password

  validates_presence_of :User, :Dir, :system_user
  validates :new_password, presence: { if: :new_record? }
  validates :User, length: { maximum: 16 }

  default_scope { order(:User) }
  before_save :set_uid_and_md5
  before_create :set_gid

  def name
    self.User.presence
  end

  protected
  def set_uid_and_md5
    self.Uid = self.system_user.uid if self.system_user.present?
    self.PASSWORD = Digest::MD5.hexdigest(new_password) if new_password.present?
  end

  def set_gid
    self.Gid = 1000
  end
end
