require 'spec_helper'

describe NotificationsMailer do
  it 'should send support_message' do
    mail = NotificationsMailer.registration(generate(:email), 'new_login', 'user_password', 'example.com',
                                            'ssh_password', 'ftp_password', 'mysql_password', 'pgsql_password')
    expect(mail.subject).to eq('Хостинг new_login')
    expect(mail.body.encoded).to match('example.com')
    expect(mail.body.encoded).to match('user_password')
    expect(mail.body.encoded).to match('ssh_password')
    expect(mail.body.encoded).to match('ftp_password')
    expect(mail.body.encoded).to match('mysql_password')
    expect(mail.body.encoded).to match('pgsql_password')
  end
end
