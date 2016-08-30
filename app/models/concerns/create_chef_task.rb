module CreateChefTask
  extend ActiveSupport::Concern

  def create_chef_task(action)
    json = to_chef_json(action)
    if [SystemUser, SystemGroup, Apache, Vhost].include?(self.class)
      ApacheVariation.all.each do |av|
        add_task_to_redis(json, av.name)
      end
    else
      add_task_to_redis(json)
    end
  end

  protected
  def add_task_to_redis(json, queue = nil)
    queue = 'root' if queue.nil?
    $redis.lpush("tasks_for_#{queue}", json)
  end
end
