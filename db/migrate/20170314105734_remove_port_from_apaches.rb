class RemovePortFromApaches < ActiveRecord::Migration
  def change
    remove_index :apaches,column: :port, unique: true
    remove_column :apaches, :port, :integer
  end
end
