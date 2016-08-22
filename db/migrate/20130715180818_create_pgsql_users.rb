class CreatePgsqlUsers < ActiveRecord::Migration
  def change
    create_table :pgsql_users do |t|
      t.string :login
      t.string :hashed_password
      t.references :apache
      t.boolean :is_deleted, null: false, default: false
      t.timestamps
    end
    add_index :pgsql_users, :apache_id
    add_index :pgsql_users, :is_deleted
    add_index :pgsql_users, :hashed_password
  end
end
