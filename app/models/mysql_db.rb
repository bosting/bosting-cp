class MysqlDb < ActiveRecord::Base
  include DbNameValidation, CreateChefTask

  belongs_to :mysql_user

  validates :db_name, :mysql_user, presence: true
  validates :db_name, uniqueness: true, length: { maximum: 16 }

  default_scope { order(:db_name) }

  def name
    db_name
  end

  def to_chef_json(action)
    if action == :create
      mysql_db_hash = serializable_hash.slice('db_name')
      mysql_db_hash['action'] = 'create'
      mysql_db_hash
    elsif action == :destroy
      { db_name: db_name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.merge('type' => 'mysql_db', 'mysql_user' => mysql_user.login).to_json
  end
end
