class CreateRailsServerAliases < ActiveRecord::Migration
  def change
    create_table :rails_server_aliases do |t|
      t.string :name
      t.references :rails_server
      t.timestamps
    end
    add_index :rails_server_aliases, :rails_server_id
  end
end
