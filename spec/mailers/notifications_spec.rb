require 'spec_helper'

describe NotificationsMailer do
  it 'should send support_message' do
    mail = NotificationsMailer.registration(generate(:email), 'new_login', 'user_password', 'example.com',
                                            'ssh_password', 'ftp_password', 'mysql_password', 'pgsql_password')
    mail.subject.should == 'Хостинг new_login'
    mail.body.encoded.should match('example.com')
    mail.body.encoded.should match('user_password')
    mail.body.encoded.should match('ssh_password')
    mail.body.encoded.should match('ftp_password')
    mail.body.encoded.should match('mysql_password')
    mail.body.encoded.should match('pgsql_password')
  end
end
