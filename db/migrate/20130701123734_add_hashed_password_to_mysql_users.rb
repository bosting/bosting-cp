class AddHashedPasswordToMysqlUsers < ActiveRecord::Migration
  def change
    add_column :mysql_users, :hashed_password, :string
  end
end
