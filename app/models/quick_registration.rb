class QuickRegistration
  include ActiveModel::Model, PasswordGenerator

  attr_accessor :domain, :top_domain, :sub_domain, :ns1_ip_address, :ns2_ip_address, :user, :login, :email, :apache_variation,
                :ip_address, :with_ssh, :with_ftp, :with_mysql, :with_pgsql, :with_email

  validates_presence_of :domain, :ns1_ip_address, :ns2_ip_address, :login, :apache_variation, :ip_address
  validate :user_selected_or_new, :uniqueness
  validates :domain, domain: true

  def process_registration
    return unless valid?

    user = if self.user.present?
             User.find(self.user)
           else
             user_password = generate_random_password
             User.create!(email: email, password: user_password)
           end

    ssh_password = generate_random_password if with_ssh
    system_user = SystemUser.new(name: login, user: user, new_password: ssh_password)
    system_user.set_defaults(!with_ssh)
    system_user.save!

    domain = Domain.find_or_initialize_by(name: self.top_domain)
    if domain.new_record?
      domain.set_defaults
      domain.ns1_ip_address_id = ns1_ip_address
      domain.ns2_ip_address_id = ns2_ip_address
      domain.save!
    end

    type_a = DnsRecordType.find_by(name: 'A')
    domain.dns_records.create!(origin: sub_domain.blank? ? '@' : sub_domain, ip_address_id: ip_address, dns_record_type: type_a)

    apache = Apache.new(user: user, system_user: system_user)
    apache.apache_variation_id = apache_variation
    apache.ip_address_id = ip_address
    apache.set_defaults
    apache.save!

    vhost = apache.vhosts.build(server_name: self.domain, primary: true)
    vhost.set_defaults
    vhost.save!

    if self.domain == self.top_domain
      domain.dns_records.create!(origin: 'www', ip_address_id: ip_address, dns_record_type: type_a)
      vhost.vhost_aliases.create!(name: 'www.' + self.domain)
    end

    if with_ftp
      ftp_password = generate_random_password
      Ftp.create!(User: login, new_password: ftp_password, Dir: "/home/#{login}", system_user: system_user)
    end

    if with_mysql
      mysql_password = generate_random_password
      MysqlUser.create!(login: login, apache: apache, create_db: true, new_password: mysql_password)
    end

    if with_pgsql
      pgsql_password = generate_random_password
      PgsqlUser.create!(login: login, apache: apache, create_db: true, new_password: pgsql_password)
    end

    if with_email
      # todo
    end

    NotificationsMailer.registration(user.email, login, user_password, self.domain, ssh_password, ftp_password, mysql_password, pgsql_password).deliver_now
  end

  private
  def extract_top_domain
    if self.top_domain.blank? || self.sub_domain.blank?
      self.top_domain = begin
        PublicSuffix.parse(domain).domain
      rescue
        domain.split('.').last(2).join('.')
      end
      self.sub_domain = domain.sub(/\.?#{self.top_domain}$/, '')
    end
  end

  def user_selected_or_new
    if self.user.blank? && self.email.blank?
      errors.add(:user, 'необходимо выбрать пользователя или создать нового')
    end
  end

  def uniqueness
    extract_top_domain

    if Domain.where(name: domain).exists? || Vhost.where(server_name: domain).exists? || VhostAlias.where(name: domain).exists?
      errors.add(:domain, :taken)
    end

    domain_test = Domain.where(name: top_domain)
    if domain_test.exists?
      if domain_test.first.dns_records.map(&:origin).include?(sub_domain)
        errors.add(:domain, :taken)
      end
    end

    errors.add(:with_mysql, :taken) if with_mysql == '1' && (MysqlUser.where(login: login).exists? || MysqlDb.where(db_name: login).exists?)
    errors.add(:with_pgsql, :taken) if with_pgsql == '1' && (PgsqlUser.where(login: login).exists? || PgsqlDb.where(db_name: login).exists?)
    errors.add(:login, :taken) if with_ssh == '1' && SystemUser.where(name: login).exists?
    errors.add(:with_ftp, :taken) if with_ftp == '1' && Ftp.where(user: login).exists?
    errors.add(:email, :taken) if user.blank? && User.where(email: email).exists?
  end
end
