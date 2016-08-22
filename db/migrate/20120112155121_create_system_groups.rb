class CreateSystemGroups < ActiveRecord::Migration
  def change
    create_table :system_groups do |t|
      t.string :name
      t.integer :gid
      t.timestamps
    end
  end
end
