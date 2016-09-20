class ApacheDestruction
  include ActiveAttr::Model

  attribute :destroy_user, type: Boolean
  attribute :destroy_ftps, type: Boolean
  attribute :destroy_system_user, type: Boolean
  attribute :destroy_mysql_users, type: Boolean
  attribute :destroy_pgsql_users, type: Boolean
  attribute :destroy_domains, type: Boolean

  def set_defaults
    self.destroy_domains = true
    self.destroy_ftps = true
    self.destroy_user = false
    self.destroy_system_user = true
    self.destroy_mysql_users = true
    self.destroy_pgsql_users = true
  end

  def destroy_dependencies(apache)
    apache.vhosts.each do |vhost|
      vhost.destroy
      vhost.create_chef_task(:destroy)
    end
    apache.user.domains.each(&:destroy) if destroy_domains
    apache.user.destroy if destroy_user
    apache.system_user.ftps.each(&:destroy) if destroy_ftps
    if destroy_system_user
      apache.system_user.destroy
      apache.system_user.create_chef_task(:destroy)
    end
    %w(mysql pgsql).each do |sql|
      if attributes["destroy_#{sql}_users"]
        apache.public_send("#{sql}_users").each do |sql_user|
          sql_user.public_send("#{sql}_dbs").each do |db|
            db.destroy
            db.create_chef_task(:destroy)
          end
          sql_user.destroy
          sql_user.create_chef_task(:destroy)
        end
      end
    end
  end
end
