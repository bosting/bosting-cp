class RenamePhpVersionsToApacheVariations < ActiveRecord::Migration
  def change
    rename_table :php_versions, :apache_variations
    rename_column :apaches, :php_version_id, :apache_variation_id
  end
end
