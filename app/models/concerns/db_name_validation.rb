module DbNameValidation
  extend ActiveSupport::Concern

  included do
    validates :db_name, uniqueness: true
    validate :db_name_is_similar_to_db_login
  end

  def db_name_is_similar_to_db_login
    login = if respond_to?(:mysql_user)
              mysql_user.login
            elsif respond_to?(:pgsql_user)
              pgsql_user.login
            end
    return if db_name =~ /^#{login}/
    errors.add(:db_name, I18n.t('errors.db_name_not_similar', login: login))
  end
end
