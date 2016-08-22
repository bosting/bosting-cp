class CreateEmailUsers < ActiveRecord::Migration
  def change
    create_table :email_users do |t|
      t.belongs_to :email_domain, index: true
      t.string :password, limit: 106
      t.string :username, limit: 50
      t.string :email, limit: 100
      t.timestamps
    end
    add_index :email_users, :email, unique: true
  end
end
