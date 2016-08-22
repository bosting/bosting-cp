class RenamePhpVersionsRcdPathToPrefixPath < ActiveRecord::Migration
  def change
    rename_column :php_versions, :rcd_path, :prefix_path
  end
end
