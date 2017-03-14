module QuickRegistrationValidations
  extend ActiveSupport::Concern

  included do
    validates :domain, :ns1_ip_address, :ns2_ip_address, :login,
              :apache_variation, :ip_address, presence: true
    validate :user_selected_or_new, :uniqueness
    validates :domain, domain: true

    def valid?
      extract_top_domain
      super
    end
  end

  private

  def uniqueness
    uniqueness_of_domain
    uniqueness_of_ssh
    uniqueness_of_ftp
    uniqueness_of_mysql
    uniqueness_of_pgsql
    uniqueness_of_email
  end

  def uniqueness_of_domain
    errors.add(:domain, :taken) if domain_exists?

    domain_test = Domain.where(name: @top_domain)
    return unless domain_test.exists?
    return unless domain_test.first.dns_records.map(&:origin)
                             .include?(@sub_domain)
    errors.add(:domain, :taken)
  end

  def domain_exists?
    Domain.where(name: domain).exists? ||
      Vhost.where(server_name: domain).exists? ||
      VhostAlias.where(name: domain).exists?
  end

  def uniqueness_of_ssh
    return if !with_ssh || !SystemUser.where(name: login).exists?
    errors.add(:login, :taken)
  end

  def uniqueness_of_ftp
    return if !with_ftp || !Ftp.where(user: login).exists?
    errors.add(:with_ftp, :taken)
  end

  def uniqueness_of_mysql
    return if !with_mysql || !mysql_exists?
    errors.add(:with_mysql, :taken)
  end

  def mysql_exists?
    MysqlUser.where(login: login).exists? ||
      MysqlDb.where(db_name: login).exists?
  end

  def uniqueness_of_pgsql
    return if !with_pgsql || !pgsql_exists?
    errors.add(:with_pgsql, :taken)
  end

  def pgsql_exists?
    PgsqlUser.where(login: login).exists? ||
      PgsqlDb.where(db_name: login).exists?
  end

  def uniqueness_of_email
    return if user.present? || !User.where(email: email).exists?
    errors.add(:email, :taken)
  end

  def user_selected_or_new
    return if user.present? || email.present?
    errors.add(:user, 'необходимо выбрать пользователя или создать нового')
  end

  def extract_top_domain
    return if @top_domain.present? && @sub_domain.present?
    @top_domain = begin
      PublicSuffix.parse(domain).domain
    rescue
      domain.split('.').last(2).join('.')
    end
    @sub_domain = domain.sub(/\.?#{@top_domain}$/, '')
  end
end
