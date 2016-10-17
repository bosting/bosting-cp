class PgsqlDb < ActiveRecord::Base
  include DbNameValidation, CreateChefTask

  belongs_to :pgsql_user

  validates :db_name, :pgsql_user, presence: true
  validates :db_name, uniqueness: true

  default_scope { order(:db_name) }

  def name
    self.db_name
  end

  def to_chef_json(action)
    if action == :create
      pgsql_db_hash = serializable_hash.slice(*%w(db_name))
      pgsql_db_hash['action'] = 'create'
      pgsql_db_hash
    elsif action == :destroy
      { db_name: db_name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end.merge('type' => 'pgsql_db', 'pgsql_user' => pgsql_user.login).to_json
  end
end
