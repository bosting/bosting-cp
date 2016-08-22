class CreatePhpVersions < ActiveRecord::Migration
  def change
    create_table :php_versions do |t|
      t.string :name
      t.integer :position, null: false
      t.timestamps
    end
    add_index :php_versions, :position, unique: true
  end
end
