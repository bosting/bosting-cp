class CreateDnsRecords < ActiveRecord::Migration
  def change
    create_table :dns_records do |t|
      t.string :origin
      t.string :mx_priority
      t.string :value
      t.references :ip_address
      t.references :domain
      t.timestamps
    end
    add_index :dns_records, :domain_id
  end
end
