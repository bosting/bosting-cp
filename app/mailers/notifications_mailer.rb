class NotificationsMailer < ActionMailer::Base
  default from: proc {
    if Rails.env.production?
      Setting.get('email_from')
    else
      'support@lvh.me'
    end
  }

  def registration(options)
    @login          = options[:login]
    @user_password  = options[:user_password]
    @domain         = options[:domain]
    @ssh_password   = options[:ssh_password]
    @ftp_password   = options[:ftp_password]
    @mysql_password = options[:mysql_password]
    @pgsql_password = options[:pgsql_password]
    @mysql_socket   = Setting.get('mysql_socket')
    @server_domain  = Setting.get('server_domain')
    @panel_url      = Setting.panel_url
    mail(to: options[:email], subject: "Хостинг #{options[:login]}")
  end
end
