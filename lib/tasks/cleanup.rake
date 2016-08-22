namespace :bosting_cp do
  desc 'Delete all'
  task :delete_all => :environment do
    User.where(is_admin: false).delete_all
    [SystemUser, Domain, DnsRecord, Apache, Vhost, VhostAlias, MysqlUser, MysqlDb, PgsqlUser, PgsqlDb, Ftp].each(&:delete_all)
  end
end
