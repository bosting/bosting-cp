class CreateMysqlUsers < ActiveRecord::Migration
  def change
    create_table :mysql_users do |t|
      t.string :login
      t.references :apache
      t.timestamps
    end
    add_index :mysql_users, :apache_id
  end
end
