class AddActiveToVhosts < ActiveRecord::Migration
  def change
    add_column :vhosts, :active, :boolean, null: false, default: true
    add_index :vhosts, :active
  end
end
