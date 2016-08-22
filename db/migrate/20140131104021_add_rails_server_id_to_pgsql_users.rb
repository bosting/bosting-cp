class AddRailsServerIdToPgsqlUsers < ActiveRecord::Migration
  def change
    add_reference :pgsql_users, :rails_server
  end
end
