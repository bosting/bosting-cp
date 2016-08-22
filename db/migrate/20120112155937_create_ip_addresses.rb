class CreateIpAddresses < ActiveRecord::Migration
  def change
    create_table :ip_addresses do |t|
      t.string :name
      t.string :ip
      t.integer :position, null: false
      t.timestamps
    end
    add_index :ip_addresses, :position, unique: true
  end
end
