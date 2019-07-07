class PgsqlDb < ActiveRecord::Base
  include DbNameValidation, CreateChefTask

  belongs_to :pgsql_user

  validates :db_name, :pgsql_user, presence: true
  validates :db_name, uniqueness: true

  default_scope { order(:db_name) }

  def name
    db_name
  end

  def to_chef(action)
    if action == :create
      {
        db_name: db_name,
        action: 'create'
      }
    elsif action == :destroy
      { db_name: db_name, action: 'destroy' }
    else
      raise ArgumentError, "Unknown action specified: #{action}"
    end
      .merge(type: 'pgsql_db', pgsql_user: pgsql_user.login)
  end
end
