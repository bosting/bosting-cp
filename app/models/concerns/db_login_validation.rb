module DbLoginValidation
  extend ActiveSupport::Concern

  included do
    self.validates :login, uniqueness: true, presence: true
    self.validates :new_password, presence: { if: :new_record? }
    self.validate :db_login_is_similar_to_web_server_name
    self.validate :apache_or_rails_server_is_present
  end

  def db_login_is_similar_to_web_server_name
    if apache.present? || rails_server.present?
      user_name = apache ? apache.system_user.name : rails_server.name
      unless login.match /^#{user_name}/
        errors.add(:login, I18n.t('errors.db_login_not_similar', login: user_name))
      end
    end
  end

  def apache_or_rails_server_is_present
    if apache.nil? && rails_server.nil?
      errors.add(:apache, I18n.t('errors.apache_or_rails_server_required'))
    end
  end
end
