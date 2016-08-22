class CreateRailsServers < ActiveRecord::Migration
  def change
    create_table :rails_servers do |t|
      t.string :name
      t.references :user
      t.timestamps
    end
    add_index :rails_servers, :user_id
  end
end
