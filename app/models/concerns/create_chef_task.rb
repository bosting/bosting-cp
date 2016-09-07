module CreateChefTask
  extend ActiveSupport::Concern

  def create_chef_task(action)
    json = to_chef_json(action)
    if [SystemUser, SystemGroup, Apache, Vhost].include?(self.class)
      ApacheVariation.all.each do |av|
        run_chef_client(json, av.name)
      end
    else
      run_chef_client(json)
    end
  end

  protected
  def run_chef_client(json, name = 'root')
    $redis.lpush("tasks_for_#{name}", json)
    if Rails.env.production?
      system("sudo /usr/local/bin/notify_chef #{name}")
    end
  end
end
