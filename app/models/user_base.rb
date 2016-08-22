class UserBase < ActiveRecord::Base
  self.table_name = 'users'

  has_many :apaches, dependent: :destroy, foreign_key: 'user_id'
  has_many :domains, dependent: :destroy, foreign_key: 'user_id'
  has_many :email_domains, dependent: :destroy, foreign_key: 'user_id'

  default_scope { order(:email) }

  validates :email, presence: true

  def to_label
    name? ? "#{name} <#{email}>" : email
  end
end
