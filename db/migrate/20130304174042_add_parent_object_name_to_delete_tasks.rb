class AddParentObjectNameToDeleteTasks < ActiveRecord::Migration
  def change
    add_column :delete_tasks, :parent_object_name, :string
  end
end
