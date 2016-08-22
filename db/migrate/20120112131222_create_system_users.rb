class CreateSystemUsers < ActiveRecord::Migration
  def change
    create_table :system_users do |t|
      t.string :name
      t.integer :uid
      t.references :system_group
      t.timestamps
    end
  end
end
