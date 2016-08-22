class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :name, null: false
      t.string :value
      t.integer :value_type, null: false
      t.string :description
      t.timestamps null: false
    end
    add_index(:settings, :name, unique: true)
  end
end
