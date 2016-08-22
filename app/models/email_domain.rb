class EmailDomain < ActiveRecord::Base
  belongs_to :user
  has_many :email_users, dependent: :delete_all
  has_many :email_aliases, dependent: :delete_all

  after_create :add_catch_all_alias

  protected
  def add_catch_all_alias
    self.email_aliases.create(destination: 'devnull@localhost', hidden: true)
  end
end
