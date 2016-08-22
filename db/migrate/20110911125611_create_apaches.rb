class CreateApaches < ActiveRecord::Migration
  def change
    create_table :apaches do |t|
      t.references :user
      t.references :system_user
      t.references :system_group
      t.references  :ip_address
      t.integer :port
      t.integer :min_spare_servers
      t.integer :max_spare_servers
      t.integer :start_servers
      t.integer :max_clients
      t.string :server_admin
      t.references :php_version
      t.boolean :skip, null: false, default: false
      t.text :custom_config
      t.timestamps
    end
    add_index :apaches, :port, unique: true
    add_index :apaches, :user_id
    add_index :apaches, :skip
  end
end
