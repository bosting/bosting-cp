class AddCustomConfigToVhosts < ActiveRecord::Migration
  def change
    add_column :vhosts, :custom_config, :text
  end
end
