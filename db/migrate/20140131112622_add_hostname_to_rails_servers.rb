class AddHostnameToRailsServers < ActiveRecord::Migration
  def change
    add_column :rails_servers, :hostname, :string
  end
end
