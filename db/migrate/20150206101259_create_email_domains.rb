class CreateEmailDomains < ActiveRecord::Migration
  def change
    create_table :email_domains do |t|
      t.string :name, limit: 50
      t.belongs_to :user, index: true
      t.timestamps
    end
    add_index :email_domains, :name, unique: true
  end
end
