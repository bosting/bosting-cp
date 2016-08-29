module CreateChefTask
  extend ActiveSupport::Concern

  def create_chef_task(action)
    $redis.lpush('tasks', to_chef_json(action))
  end
end
