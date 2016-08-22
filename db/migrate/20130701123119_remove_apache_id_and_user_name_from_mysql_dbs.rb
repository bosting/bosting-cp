class RemoveApacheIdAndUserNameFromMysqlDbs < ActiveRecord::Migration
  def up
    remove_index :mysql_dbs, :apache_id
    remove_column :mysql_dbs, :apache_id
    remove_column :mysql_dbs, :user_name
  end

  def down
    add_column :mysql_dbs, :apache_id, :string
    add_index :mysql_dbs, :apache_id
    add_column :mysql_dbs, :user_name, :string
  end
end
