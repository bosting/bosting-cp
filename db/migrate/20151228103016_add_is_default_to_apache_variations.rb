class AddIsDefaultToApacheVariations < ActiveRecord::Migration
  def change
    add_column :apache_variations, :is_default, :boolean, default: false, null: false
    add_index :apache_variations, :is_default
  end
end
