class MysqlDb < ActiveRecord::Base
  include DbNameValidation

  belongs_to :mysql_user

  validates :db_name, :mysql_user, presence: true
  validates :db_name, uniqueness: true

  default_scope { order(:db_name) }
  scope :not_deleted, -> { where(is_deleted: false) }

  def name
    self.db_name
  end

  def destroy
    update_attribute :is_deleted, true
  end
end
