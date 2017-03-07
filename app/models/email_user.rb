class EmailUser < ActiveRecord::Base
  include EmailCommon, PasswordGenerator

  attr_accessor :new_password
  before_save :hash_new_password

  default_scope { order(:email) }

  def name
    username
  end

  private

  def hash_new_password
    self.password = new_password.crypt('$6$' + generate_random_password(16)) if new_password.present?
  end
end
