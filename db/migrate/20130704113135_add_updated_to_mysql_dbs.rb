class AddUpdatedToMysqlDbs < ActiveRecord::Migration
  def change
    add_column :mysql_dbs, :updated, :boolean, default: true, null: false
    add_index :mysql_dbs, :updated
  end
end
