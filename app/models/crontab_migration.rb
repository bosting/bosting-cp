class CrontabMigration
  include CreateChefTask

  attr_accessor :user, :source_jail, :destination_jail

  def initialize(user, source_jail, destination_jail)
    @user = user
    @source_jail = source_jail
    @destination_jail = destination_jail
  end

  def to_chef_json(action, apache_variation = nil)
    { 'user' => @user, 'source_jail' => @source_jail, 'destination_jail' => @destination_jail,
      'type' => 'crontab_migration', 'action' => action }.to_json
  end
end
