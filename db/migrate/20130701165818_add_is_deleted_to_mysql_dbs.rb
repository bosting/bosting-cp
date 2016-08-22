class AddIsDeletedToMysqlDbs < ActiveRecord::Migration
  def change
    add_column :mysql_dbs, :is_deleted, :boolean, null: false, default: false
    add_index :mysql_dbs, :is_deleted
  end
end
