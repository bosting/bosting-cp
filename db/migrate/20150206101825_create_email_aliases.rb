class CreateEmailAliases < ActiveRecord::Migration
  def change
    create_table :email_aliases do |t|
      t.belongs_to :email_domain, index: true
      t.string :username, limit: 50
      t.string :email, limit: 100
      t.string :destination, limit: 100
      t.timestamps
    end
    add_index :email_aliases, :email, unique: true
  end
end
