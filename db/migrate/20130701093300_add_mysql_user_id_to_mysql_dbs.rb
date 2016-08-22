class AddMysqlUserIdToMysqlDbs < ActiveRecord::Migration
  def change
    add_column :mysql_dbs, :mysql_user_id, :integer
    add_index :mysql_dbs, :mysql_user_id
  end
end
