class AddSystemUserShellIdToSystemUsers < ActiveRecord::Migration
  def change
    add_column :system_users, :system_user_shell_id, :integer
  end
end
