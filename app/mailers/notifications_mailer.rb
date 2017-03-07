class NotificationsMailer < ActionMailer::Base
  default from: proc {
    if Rails.env.production?
      Setting.get('email_from')
    else
      'support@lvh.me'
    end
  }

  def registration(email, login, user_password, domain, ssh_password, ftp_password, mysql_password, pgsql_password)
    @login = login
    @user_password = user_password
    @domain = domain
    @ssh_password = ssh_password
    @ftp_password = ftp_password
    @mysql_password = mysql_password
    @pgsql_password = pgsql_password
    @mysql_socket = Setting.get('mysql_socket')
    @server_domain = Setting.get('server_domain')
    @panel_url = Setting.panel_url
    mail(to: email, subject: "Хостинг #{login}")
  end
end
