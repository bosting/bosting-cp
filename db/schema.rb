# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190707150814) do

  create_table "apache_variations", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "position",       limit: 4,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_default",                 default: false, null: false
    t.string   "description",    limit: 255
    t.string   "ip",             limit: 255,                 null: false
    t.string   "apache_version", limit: 255,                 null: false
    t.string   "php_version",    limit: 255,                 null: false
  end

  add_index "apache_variations", ["is_default"], name: "index_apache_variations_on_is_default", using: :btree
  add_index "apache_variations", ["position"], name: "index_apache_variations_on_position", unique: true, using: :btree

  create_table "apaches", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.integer  "system_user_id",      limit: 4
    t.integer  "system_group_id",     limit: 4
    t.integer  "ip_address_id",       limit: 4
    t.integer  "min_spare_servers",   limit: 4
    t.integer  "max_spare_servers",   limit: 4
    t.integer  "start_servers",       limit: 4
    t.integer  "max_clients",         limit: 4
    t.string   "server_admin",        limit: 255
    t.integer  "apache_variation_id", limit: 4
    t.boolean  "active",                            default: true,  null: false
    t.text     "custom_config",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "skip_nginx",                        default: false, null: false
  end

  add_index "apaches", ["active"], name: "index_apaches_on_skip", using: :btree
  add_index "apaches", ["system_user_id"], name: "index_apaches_on_system_user_id", unique: true, using: :btree
  add_index "apaches", ["user_id"], name: "index_apaches_on_user_id", using: :btree

  create_table "dns_record_types", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "position",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "dns_record_types", ["position"], name: "index_dns_record_types_on_position", unique: true, using: :btree

  create_table "dns_records", force: :cascade do |t|
    t.string   "origin",             limit: 255
    t.string   "mx_priority",        limit: 255
    t.string   "value",              limit: 255
    t.integer  "ip_address_id",      limit: 4
    t.integer  "domain_id",          limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dns_record_type_id", limit: 4
  end

  add_index "dns_records", ["domain_id"], name: "index_dns_records_on_domain_id", using: :btree

  create_table "domains", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.integer  "user_id",           limit: 4
    t.string   "email",             limit: 255
    t.integer  "ns1_ip_address_id", limit: 4
    t.integer  "ns2_ip_address_id", limit: 4
    t.integer  "registrar_id",      limit: 4
    t.date     "expires_on"
    t.boolean  "active",                        default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "serial",            limit: 255
  end

  add_index "domains", ["active"], name: "index_domains_on_active", using: :btree
  add_index "domains", ["name"], name: "index_domains_on_name", unique: true, using: :btree
  add_index "domains", ["user_id"], name: "index_domains_on_user_id", using: :btree

  create_table "email_aliases", force: :cascade do |t|
    t.integer  "email_domain_id", limit: 4
    t.string   "username",        limit: 50
    t.string   "email",           limit: 100
    t.string   "destination",     limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "hidden",                      default: false, null: false
  end

  add_index "email_aliases", ["email"], name: "index_email_aliases_on_email", unique: true, using: :btree
  add_index "email_aliases", ["email_domain_id"], name: "index_email_aliases_on_email_domain_id", using: :btree
  add_index "email_aliases", ["hidden"], name: "index_email_aliases_on_hidden", using: :btree

  create_table "email_domains", force: :cascade do |t|
    t.string   "name",       limit: 50
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_domains", ["name"], name: "index_email_domains_on_name", unique: true, using: :btree
  add_index "email_domains", ["user_id"], name: "index_email_domains_on_user_id", using: :btree

  create_table "email_users", force: :cascade do |t|
    t.integer  "email_domain_id", limit: 4
    t.string   "password",        limit: 106
    t.string   "username",        limit: 50
    t.string   "email",           limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_users", ["email"], name: "index_email_users_on_email", unique: true, using: :btree
  add_index "email_users", ["email_domain_id"], name: "index_email_users_on_email_domain_id", using: :btree

  create_table "ip_addresses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "ip",         limit: 255
    t.integer  "position",   limit: 4,                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_default",             default: false, null: false
  end

  add_index "ip_addresses", ["is_default"], name: "index_ip_addresses_on_is_default", using: :btree
  add_index "ip_addresses", ["name"], name: "index_ip_addresses_on_name", unique: true, using: :btree
  add_index "ip_addresses", ["position"], name: "index_ip_addresses_on_position", unique: true, using: :btree

  create_table "mysql_dbs", force: :cascade do |t|
    t.string   "db_name",       limit: 255
    t.integer  "size",          limit: 4,   default: 0, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.integer  "mysql_user_id", limit: 4
  end

  add_index "mysql_dbs", ["db_name"], name: "index_mysql_dbs_on_db_name", unique: true, using: :btree
  add_index "mysql_dbs", ["mysql_user_id"], name: "index_mysql_dbs_on_mysql_user_id", using: :btree

  create_table "mysql_users", force: :cascade do |t|
    t.string   "login",           limit: 255
    t.integer  "apache_id",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "hashed_password", limit: 255
    t.integer  "rails_server_id", limit: 4
  end

  add_index "mysql_users", ["apache_id"], name: "index_mysql_users_on_apache_id", using: :btree
  add_index "mysql_users", ["hashed_password"], name: "index_mysql_users_on_hashed_password", using: :btree
  add_index "mysql_users", ["login"], name: "index_mysql_users_on_login", unique: true, using: :btree

  create_table "pgsql_dbs", force: :cascade do |t|
    t.string   "db_name",       limit: 255
    t.integer  "pgsql_user_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "pgsql_dbs", ["db_name"], name: "index_pgsql_dbs_on_db_name", unique: true, using: :btree
  add_index "pgsql_dbs", ["pgsql_user_id"], name: "index_pgsql_dbs_on_pgsql_user_id", using: :btree

  create_table "pgsql_users", force: :cascade do |t|
    t.string   "login",           limit: 255
    t.string   "hashed_password", limit: 255
    t.integer  "apache_id",       limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "rails_server_id", limit: 4
  end

  add_index "pgsql_users", ["apache_id"], name: "index_pgsql_users_on_apache_id", using: :btree
  add_index "pgsql_users", ["hashed_password"], name: "index_pgsql_users_on_hashed_password", using: :btree
  add_index "pgsql_users", ["login"], name: "index_pgsql_users_on_login", unique: true, using: :btree

  create_table "pureftpd", force: :cascade do |t|
    t.string  "User",           limit: 16,  default: "", null: false
    t.string  "PASSWORD",       limit: 64,  default: "", null: false
    t.integer "Uid",            limit: 4,   default: -1, null: false
    t.integer "Gid",            limit: 4,   default: -1, null: false
    t.string  "Dir",            limit: 128, default: "", null: false
    t.integer "ULBandwidth",    limit: 4,   default: 0,  null: false
    t.integer "DLBandwidth",    limit: 4,   default: 0,  null: false
    t.integer "QuotaSize",      limit: 4,   default: 0,  null: false
    t.integer "system_user_id", limit: 4
  end

  add_index "pureftpd", ["User"], name: "User", unique: true, using: :btree

  create_table "rails_server_aliases", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.integer  "rails_server_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "rails_server_aliases", ["rails_server_id"], name: "index_rails_server_aliases_on_rails_server_id", using: :btree

  create_table "rails_servers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "hostname",   limit: 255
  end

  add_index "rails_servers", ["user_id"], name: "index_rails_servers_on_user_id", using: :btree

  create_table "registrars", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255,   null: false
    t.text     "data",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "value",       limit: 255
    t.integer  "value_type",  limit: 4,   null: false
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "settings", ["name"], name: "index_settings_on_name", unique: true, using: :btree

  create_table "ssl_cert_chains", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.text     "certificate", limit: 65535, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "system_groups", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "gid",        limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_user_shells", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "path",       limit: 255
    t.boolean  "is_default",             default: false, null: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "system_user_shells", ["is_default"], name: "index_system_user_shells_on_is_default", using: :btree

  create_table "system_users", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.integer  "uid",                  limit: 4
    t.integer  "system_group_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",              limit: 4
    t.integer  "system_user_shell_id", limit: 4
    t.string   "hashed_password",      limit: 255
  end

  add_index "system_users", ["hashed_password"], name: "index_system_users_on_hashed_password", using: :btree
  add_index "system_users", ["name"], name: "index_system_users_on_name", unique: true, using: :btree
  add_index "system_users", ["uid"], name: "index_system_users_on_uid", unique: true, using: :btree
  add_index "system_users", ["user_id"], name: "index_system_users_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 128, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "authentication_token",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin",                           default: false, null: false
    t.string   "name",                   limit: 255
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "vhost_aliases", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "vhost_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "vhost_aliases", ["name"], name: "index_vhost_aliases_on_name", unique: true, using: :btree
  add_index "vhost_aliases", ["vhost_id"], name: "index_vhost_aliases_on_vhost_id", using: :btree

  create_table "vhosts", force: :cascade do |t|
    t.integer  "apache_id",         limit: 4
    t.boolean  "primary",                         default: false, null: false
    t.string   "server_name",       limit: 255
    t.boolean  "indexes",                         default: false, null: false
    t.string   "directory_index",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                          default: true,  null: false
    t.boolean  "skip_nginx",                      default: false, null: false
    t.boolean  "ssl",                             default: false, null: false
    t.integer  "ssl_ip_address_id", limit: 4
    t.integer  "ssl_port",          limit: 4
    t.integer  "ssl_cert_chain_id", limit: 4
    t.text     "ssl_certificate",   limit: 65535
    t.text     "ssl_key",           limit: 65535
    t.text     "custom_config",     limit: 65535
  end

  add_index "vhosts", ["active"], name: "index_vhosts_on_active", using: :btree
  add_index "vhosts", ["apache_id"], name: "index_vhosts_on_apache_id", using: :btree
  add_index "vhosts", ["server_name"], name: "index_vhosts_on_server_name", unique: true, using: :btree

end
