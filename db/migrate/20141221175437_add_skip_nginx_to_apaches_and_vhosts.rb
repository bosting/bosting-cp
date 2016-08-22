class AddSkipNginxToApachesAndVhosts < ActiveRecord::Migration
  def change
    add_column :apaches, :skip_nginx, :boolean, null: false, default: false
    add_column :vhosts, :skip_nginx, :boolean, null: false, default: false
  end
end
