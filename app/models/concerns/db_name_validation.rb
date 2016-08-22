module DbNameValidation
  extend ActiveSupport::Concern

  included do
    self.validates :db_name, uniqueness: true
    self.validate :db_name_is_similar_to_db_login
  end

  def db_name_is_similar_to_db_login
    login = if self.respond_to?(:mysql_user)
              mysql_user.login
            elsif self.respond_to?(:pgsql_user)
              pgsql_user.login
            end
    errors.add(:db_name, I18n.t('errors.db_name_not_similar', login: login)) unless db_name.match /^#{login}/
  end
end
