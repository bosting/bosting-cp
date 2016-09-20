class RemoveTasksFields < ActiveRecord::Migration
  def change
    drop_table :delete_tasks

    remove_index(:apaches, :updated)
    remove_index(:apaches, :is_deleted)
    remove_columns(:apaches, :updated, :is_deleted, :av_changed, :apache_variation_prev_id)

    remove_index(:dns_records, :is_deleted)
    remove_column(:dns_records, :is_deleted)

    remove_index(:domains, :updated)
    remove_index(:domains, :is_deleted)
    remove_columns(:domains, :updated, :is_deleted)

    remove_index(:mysql_dbs, :updated)
    remove_index(:mysql_dbs, :is_deleted)
    remove_columns(:mysql_dbs, :updated, :is_deleted)

    remove_index(:mysql_users, :is_deleted)
    remove_column(:mysql_users, :is_deleted)

    remove_index(:pgsql_dbs, :updated)
    remove_index(:pgsql_dbs, :is_deleted)
    remove_columns(:pgsql_dbs, :updated, :is_deleted)

    remove_index(:pgsql_users, :is_deleted)
    remove_column(:pgsql_users, :is_deleted)

    remove_index(:system_users, :updated)
    remove_index(:system_users, :is_deleted)
    remove_columns(:system_users, :updated, :is_deleted)

    remove_index(:vhosts, :is_deleted)
    remove_column(:vhosts, :is_deleted)
  end
end
