class AddUserIdToSystemUsers < ActiveRecord::Migration
  def change
    add_column :system_users, :user_id, :integer
    add_index :system_users, :user_id
  end
end
