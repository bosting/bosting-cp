class CreateSslCertChains < ActiveRecord::Migration
  def change
    create_table :ssl_cert_chains do |t|
      t.string :name, null: false
      t.text :certificate, null: false
      t.timestamps null: false
    end
  end
end
