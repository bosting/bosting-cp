module HostingServicesGenerators
  extend ActiveSupport::Concern

  private

  def create_user
    return User.find(user) if user.present?
    User.create!(email: email, password: @user_password)
  end

  def create_system_user(options)
    system_user = if with_ssh
                    SystemUser.build_with_ssh(
                      options.merge(new_password: @ssh_password)
                    )
                  else
                    SystemUser.build_without_ssh(options)
                  end
    system_user.save!
    system_user.create_chef_task(:create)
    system_user
  end

  def create_domain(user)
    domain = Domain.find_or_initialize_by(name: @top_domain)
    if domain.new_record?
      domain.set_defaults
      domain.user = user
      domain.ns1_ip_address_id = ns1_ip_address
      domain.ns2_ip_address_id = ns2_ip_address
      domain.save!
    end
    create_dns_records(domain)
    domain
  end

  def create_dns_records(domain)
    type_a = DnsRecordType.find_a
    domain.dns_records.create!(origin: @sub_domain.blank? ? '@' : @sub_domain,
                               ip_address_id: ip_address,
                               dns_record_type: type_a)

    if self.domain == @top_domain
      domain.dns_records.create!(origin: 'www', ip_address_id: ip_address,
                                 dns_record_type: type_a)
    end
  end

  def create_apache(options)
    apache = Apache.new(system_user: options[:system_user],
                        user: options[:user])
    apache.set_defaults
    apache.apache_variation_id = apache_variation
    apache.ip_address_id = ip_address
    apache.save!
    apache.create_chef_task(:create)

    create_vhosts(apache)

    apache
  end

  def create_vhosts(apache)
    vhost = apache.vhosts.build(server_name: domain, primary: true)
    vhost.set_defaults
    vhost.save!

    if domain == @top_domain
      vhost.vhost_aliases.create!(name: 'www.' + domain)
    end

    vhost.create_chef_task(:create)
  end

  def create_ftp(system_user)
    Ftp.create!(User: login, new_password: @ftp_password,
                Dir: "/home/#{login}", system_user: system_user)
  end

  def create_mysql(apache)
    mysql_user = MysqlUser.create!(login: login, apache: apache,
                                   new_password: @mysql_password)
    mysql_user.create_chef_task(:create)
    mysql_db = MysqlDb.create!(db_name: login, mysql_user: mysql_user)
    mysql_db.create_chef_task(:create)
  end

  def create_pgsql(apache)
    pgsql_user = PgsqlUser.create!(login: login, apache: apache,
                                   new_password: @pgsql_password)
    pgsql_user.create_chef_task(:create)
    pgsql_db = PgsqlDb.create!(db_name: login, pgsql_user: pgsql_user)
    pgsql_db.create_chef_task(:create)
  end

  def create_email
    # TODO
  end
end
