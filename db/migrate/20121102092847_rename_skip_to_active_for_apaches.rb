class RenameSkipToActiveForApaches < ActiveRecord::Migration
  def up
    rename_column :apaches, :skip, :active
    Apache.update_all('`active`=NOT(`active`)')
  end

  def down
    rename_column :apaches, :active, :skip
    Apache.update_all('`skip`=NOT(`skip`)')
  end
end
