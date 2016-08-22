class AddIndexesToDbForSorting < ActiveRecord::Migration
  def change
    add_index :mysql_users, :login
    add_index :mysql_dbs, :db_name
    add_index :pgsql_users, :login
    add_index :pgsql_dbs, :db_name
  end
end
