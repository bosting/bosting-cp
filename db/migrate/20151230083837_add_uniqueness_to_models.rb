class AddUniquenessToModels < ActiveRecord::Migration
  def change
    add_index :apaches, :system_user_id, unique: true
    add_index :domains, :name, unique: true
    add_index :ip_addresses, :name, unique: true
    remove_index :mysql_dbs, :db_name
    add_index :mysql_dbs, :db_name, unique: true
    remove_index :mysql_users, :login
    add_index :mysql_users, :login, unique: true
    remove_index :pgsql_dbs, :db_name
    add_index :pgsql_dbs, :db_name, unique: true
    remove_index :pgsql_users, :login
    add_index :pgsql_users, :login, unique: true
    add_index :system_users, :name, unique: true
    add_index :system_users, :uid, unique: true
    add_index :vhosts, :server_name, unique: true
    add_index :vhost_aliases, :name, unique: true
  end
end
