class AddApacheVariationPrevIdToApaches < ActiveRecord::Migration
  def change
    add_column :apaches, :apache_variation_prev_id, :integer
  end
end
