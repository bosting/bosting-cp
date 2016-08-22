class SetApacheActiveDefaultToTrue < ActiveRecord::Migration
  def up
    change_column_default :apaches, :active, true
  end

  def down
    change_column_default :apaches, :active, false
  end
end
