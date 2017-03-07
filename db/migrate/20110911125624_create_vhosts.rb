class CreateVhosts < ActiveRecord::Migration
  def change
    create_table :vhosts do |t|
      t.references :apache
      t.boolean :primary, null: false, default: false
      t.string :server_name
      t.text :server_alias
      t.boolean :indexes, null: false, default: false
      t.string :directory_index
      t.timestamps
    end
    add_index :vhosts, :apache_id
  end
end
