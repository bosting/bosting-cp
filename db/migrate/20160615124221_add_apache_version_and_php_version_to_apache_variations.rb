class AddApacheVersionAndPhpVersionToApacheVariations < ActiveRecord::Migration
  def change
    add_column :apache_variations, :apache_version, :string, null: false
    add_column :apache_variations, :php_version, :string, null: false
  end
end
