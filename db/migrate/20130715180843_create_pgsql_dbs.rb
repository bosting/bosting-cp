class CreatePgsqlDbs < ActiveRecord::Migration
  def change
    create_table :pgsql_dbs do |t|
      t.string :db_name
      t.references :pgsql_user
      t.boolean :is_deleted, null: false, default: false
      t.boolean :updated, default: true, null: false
      t.timestamps
    end
    add_index :pgsql_dbs, :pgsql_user_id
    add_index :pgsql_dbs, :is_deleted
    add_index :pgsql_dbs, :updated
  end
end
