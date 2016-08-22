class AddIsDeletedField < ActiveRecord::Migration
  def change
    add_column :apaches, :is_deleted, :boolean, null: false, default: false
    add_column :vhosts, :is_deleted, :boolean, null: false, default: false
    add_column :domains, :is_deleted, :boolean, null: false, default: false

    add_index :apaches, :is_deleted
    add_index :vhosts, :is_deleted
    add_index :domains, :is_deleted
  end
end
