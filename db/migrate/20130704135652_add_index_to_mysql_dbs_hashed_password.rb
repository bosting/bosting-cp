class AddIndexToMysqlDbsHashedPassword < ActiveRecord::Migration
  def change
    add_index :mysql_users, :hashed_password
  end
end
