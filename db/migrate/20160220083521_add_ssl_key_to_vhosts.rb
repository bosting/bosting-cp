class AddSslKeyToVhosts < ActiveRecord::Migration
  def change
    add_column :vhosts, :ssl_key, :text
  end
end
