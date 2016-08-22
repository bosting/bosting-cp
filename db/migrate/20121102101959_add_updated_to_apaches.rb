class AddUpdatedToApaches < ActiveRecord::Migration
  def change
    add_column :apaches, :updated, :boolean, default: false, null: false
    add_index :apaches, :updated
  end
end
