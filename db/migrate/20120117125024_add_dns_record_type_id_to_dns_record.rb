class AddDnsRecordTypeIdToDnsRecord < ActiveRecord::Migration
  def change
    add_column :dns_records, :dns_record_type_id, :integer
  end
end
