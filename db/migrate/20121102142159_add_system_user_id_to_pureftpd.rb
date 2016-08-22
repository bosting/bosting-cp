class AddSystemUserIdToPureftpd < ActiveRecord::Migration
  def change
    add_column :pureftpd, :system_user_id, :integer
  end
end
