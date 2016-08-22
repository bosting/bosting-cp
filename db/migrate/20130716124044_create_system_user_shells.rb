class CreateSystemUserShells < ActiveRecord::Migration
  def change
    create_table :system_user_shells do |t|
      t.string :name
      t.string :path
      t.boolean :is_default, null: false, default: false
      t.timestamps
    end
    add_index :system_user_shells, :is_default
  end
end
