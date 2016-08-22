class AddUpdatedAndIsDeletedToSystemUsers < ActiveRecord::Migration
  def change
    add_column :system_users, :updated, :boolean, default: false, null: false
    add_column :system_users, :is_deleted, :boolean, default: false, null: false

    add_index :system_users, :updated
    add_index :system_users, :is_deleted
  end
end
