class AddAvChangedToApaches < ActiveRecord::Migration
  def change
    add_column :apaches, :av_changed, :boolean, null: false, default: false
  end
end
