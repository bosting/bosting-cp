module CreateChefTask
  extend ActiveSupport::Concern

  def create_chef_task(action)
    if [SystemUser, SystemGroup, Apache, Vhost].include?(self.class)
      ApacheVariation.all.each do |av|
        run_chef_client(to_chef(action, av).to_json, av.name)
      end
    end
    if [SystemUser, SystemGroup, Domain, Apache, Vhost, MysqlUser, MysqlDb,
        PgsqlUser, PgsqlDb, CrontabMigration].include?(self.class)
      run_chef_client(to_chef(action).to_json)
    end
  end

  private

  def run_chef_client(json, name = 'root')
    $redis.lpush("tasks_for_#{name}", json)
    if Rails.env.production?
      # Workaround explained: https://github.com/rbenv/rbenv/issues/1072
      system("RBENV_HOOK_PATH=/usr/local/rbenv/rbenv.d && sudo /usr/local/bin/notify_chef #{name}")
    end
  end
end
