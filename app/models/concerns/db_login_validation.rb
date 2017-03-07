module DbLoginValidation
  extend ActiveSupport::Concern

  included do
    validates :login, uniqueness: true, presence: true
    validates :new_password, presence: { if: :new_record? }
    validate :db_login_is_similar_to_web_server_name
    validate :apache_or_rails_server_is_present
  end

  def db_login_is_similar_to_web_server_name
    return if apache.blank? && rails_server.blank?
    user_name = apache ? apache.system_user.name : rails_server.name
    return if login =~ /^#{user_name}/
    errors.add(:login, I18n.t('errors.db_login_not_similar', login: user_name))
  end

  def apache_or_rails_server_is_present
    return if apache.present? || rails_server.present?
    errors.add(:apache, I18n.t('errors.apache_or_rails_server_required'))
  end
end
