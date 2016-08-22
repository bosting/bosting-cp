class CreateDeleteTasks < ActiveRecord::Migration
  def change
    create_table :delete_tasks do |t|
      t.string :name
      t.references :delete_task_type
      t.timestamps
    end
    add_index :delete_tasks, :delete_task_type_id
  end
end
