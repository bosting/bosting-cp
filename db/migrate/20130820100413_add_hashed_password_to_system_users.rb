class AddHashedPasswordToSystemUsers < ActiveRecord::Migration
  def change
    add_column :system_users, :hashed_password, :string
    add_index :system_users, :hashed_password
  end
end
