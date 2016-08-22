class AddRailsServerIdToMysqlUsers < ActiveRecord::Migration
  def change
    add_reference :mysql_users, :rails_server
  end
end
