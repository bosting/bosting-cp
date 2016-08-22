class AddIsDefaultToIpAddresses < ActiveRecord::Migration
  def change
    add_column :ip_addresses, :is_default, :boolean, default: false, null: false
    add_index :ip_addresses, :is_default
  end
end
