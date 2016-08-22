class AddIpToApacheVariations < ActiveRecord::Migration
  def change
    add_column :apache_variations, :ip, :string, null: false
  end
end
