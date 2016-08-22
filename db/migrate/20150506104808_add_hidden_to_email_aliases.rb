class AddHiddenToEmailAliases < ActiveRecord::Migration
  def change
    add_column :email_aliases, :hidden, :boolean, null: false, default: false
    add_index :email_aliases, :hidden
  end
end
