class QuickRegistration
  include ActiveAttr::Model, PasswordGenerator, HostingServicesGenerators

  attribute :domain
  attribute :ns1_ip_address
  attribute :ns2_ip_address
  attribute :user
  attribute :login
  attribute :email
  attribute :apache_variation
  attribute :ip_address
  attribute :with_ssh, type: Boolean
  attribute :with_ftp, type: Boolean
  attribute :with_mysql, type: Boolean
  attribute :with_pgsql, type: Boolean
  attribute :with_email, type: Boolean

  include QuickRegistrationValidations

  def process_registration
    return unless valid?

    generate_all_passwords
    user = create_user
    create_all_services(user)
    send_email_to_user(user)
  end

  private

  def generate_all_passwords
    @user_password  = generate_random_password
    @ssh_password   = generate_random_password if with_ssh
    @ftp_password   = generate_random_password if with_ftp
    @mysql_password = generate_random_password if with_mysql
    @pgsql_password = generate_random_password if with_pgsql
  end

  def create_all_services(user)
    system_user = create_system_user(login: login, user: user)

    create_domain(user)

    apache = create_apache(system_user: system_user, user: user)

    # We really need to create system_user two times. First time it is required
    # for apache to be created, second time it updates chroot_directory for
    # system_user.
    system_user.create_chef_task(:create)

    create_ftp(system_user) if with_ftp
    create_mysql(apache)    if with_mysql
    create_pgsql(apache)    if with_pgsql
    create_email            if with_email
  end

  def send_email_to_user(user)
    NotificationsMailer.registration(
      email: user.email,
      login: login,
      user_password: @user_password,
      domain: domain,
      ssh_password: @ssh_password,
      ftp_password: @ftp_password,
      mysql_password: @mysql_password,
      pgsql_password: @pgsql_password
    ).deliver_now
  end
end
