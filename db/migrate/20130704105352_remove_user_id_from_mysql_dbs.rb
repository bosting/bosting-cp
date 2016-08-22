class RemoveUserIdFromMysqlDbs < ActiveRecord::Migration
  def up
    remove_index :mysql_dbs, :user_id
    remove_column :mysql_dbs, :user_id
  end

  def down
    add_column :mysql_dbs, :user_id, :string
    add_index :mysql_dbs, :user_id
  end
end
