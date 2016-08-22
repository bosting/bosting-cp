class CreateVhostAliases < ActiveRecord::Migration
  def up
    create_table :vhost_aliases do |t|
      t.string :name
      t.references :vhost
      t.timestamps
    end
    add_index :vhost_aliases, :vhost_id

    VhostAlias.reset_column_information
    Vhost.all.each do |vhost|
      vhost.server_alias.split(' ').each do |vhost_alias|
        VhostAlias.create!(vhost: vhost, name: vhost_alias)
      end
    end

    remove_column :vhosts, :server_alias
  end

  def down
    add_column :vhosts, :server_alias, :string

    Vhost.reset_column_information
    Vhost.all.each { |vhost| vhost.update_attribute :server_alias, vhost.vhost_aliases.map(&:name).join(' ') }

    drop_table :vhost_aliases
  end
end
