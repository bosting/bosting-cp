class AddIsDeletedToDnsRecords < ActiveRecord::Migration
  def change
    add_column :dns_records, :is_deleted, :boolean, null: false, default: false
    add_index :dns_records, :is_deleted
  end
end
