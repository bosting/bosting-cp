require 'spec_helper'

describe NotificationsMailer do
  before { create_settings }

  it 'should send support_message' do
    mail = NotificationsMailer.registration(
      email: generate(:email),
      login: 'new_login',
      user_password: 'user_password',
      domain: 'example.com',
      ssh_password: 'ssh_password',
      ftp_password: 'ftp_password',
      mysql_password: 'mysql_password',
      pgsql_password: 'pgsql_password')
    expect(mail.subject).to eq('Хостинг new_login')
    expect(mail.body.encoded).to match('example.com')
    expect(mail.body.encoded).to match('user_password')
    expect(mail.body.encoded).to match('ssh_password')
    expect(mail.body.encoded).to match('ftp_password')
    expect(mail.body.encoded).to match('mysql_password')
    expect(mail.body.encoded).to match('pgsql_password')
  end
end
