class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.references :user
      t.string :email
      t.integer :ns1_ip_address_id
      t.integer :ns2_ip_address_id
      t.references :registrar
      t.date :expires_on
      t.boolean :updated, null: false, default: false
      t.boolean :active, null: false, default: true
      t.timestamps
    end
    add_index :domains, :user_id
    add_index :domains, :updated
    add_index :domains, :active
  end
end
