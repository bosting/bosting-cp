module CreateChefTask
  extend ActiveSupport::Concern

  def create_chef_task(action)
    if [SystemUser, SystemGroup, Apache, Vhost].include?(self.class)
      ApacheVariation.all.each do |av|
        run_chef_client(to_chef_json(action, av), av.name)
      end
    end
    if [SystemUser, SystemGroup, Domain, Apache, Vhost, MysqlUser, MysqlDb,
        PgsqlUser, PgsqlDb, CrontabMigration].include?(self.class)
      run_chef_client(to_chef_json(action))
    end
  end

  private

  def run_chef_client(json, name = 'root')
    $redis.lpush("tasks_for_#{name}", json)
    system("sudo /usr/local/bin/notify_chef #{name}") if Rails.env.production?
  end
end
