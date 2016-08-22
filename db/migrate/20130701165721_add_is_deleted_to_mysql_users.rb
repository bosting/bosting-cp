class AddIsDeletedToMysqlUsers < ActiveRecord::Migration
  def change
    add_column :mysql_users, :is_deleted, :boolean, null: false, default: false
    add_index :mysql_users, :is_deleted
  end
end
