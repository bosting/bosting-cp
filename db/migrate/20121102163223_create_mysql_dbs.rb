class CreateMysqlDbs < ActiveRecord::Migration
  def change
    create_table :mysql_dbs do |t|
      t.string :db_name
      t.string :user_name
      t.references :apache
      t.integer :size, default: 0, null: false
      t.references :user
      t.timestamps
    end
    add_index :mysql_dbs, :apache_id
    add_index :mysql_dbs, :user_id
  end
end
