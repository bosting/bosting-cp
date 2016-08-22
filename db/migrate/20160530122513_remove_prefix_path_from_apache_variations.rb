class RemovePrefixPathFromApacheVariations < ActiveRecord::Migration
  def change
    remove_column :apache_variations, :prefix_path
  end
end
