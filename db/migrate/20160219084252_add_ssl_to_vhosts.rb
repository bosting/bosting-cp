class AddSslToVhosts < ActiveRecord::Migration
  def change
    add_column :vhosts, :ssl, :boolean, null: false, default: false
    add_belongs_to :vhosts, :ssl_ip_address
    add_column :vhosts, :ssl_port, :integer
    add_belongs_to :vhosts, :ssl_cert_chain
    add_column :vhosts, :ssl_certificate, :text
  end
end
