class AddSerialToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :serial, :string
  end
end
