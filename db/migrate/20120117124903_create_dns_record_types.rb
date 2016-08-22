class CreateDnsRecordTypes < ActiveRecord::Migration
  def change
    create_table :dns_record_types do |t|
      t.string :name
      t.integer :position
      t.timestamps
    end
    add_index :dns_record_types, :position, unique: true
  end
end
