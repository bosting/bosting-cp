class AddRcdPathToPhpVersions < ActiveRecord::Migration
  def change
    add_column :php_versions, :rcd_path, :string
  end
end
