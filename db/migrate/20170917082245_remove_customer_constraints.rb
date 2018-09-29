class RemoveCustomerConstraints < ActiveRecord::Migration[5.1]
  def change
    execute "CREATE EXTENSION IF NOT EXISTS hstore"
    change_column_null :customers, :email, true
    change_column_null :customers, :first_name, true

    change_table(:customers) do |t|
      t.remove :facebook_uid
      t.remove :district
      t.remove :city
      t.hstore :address
      t.string :external_uid
      t.string :profile_image_url
      t.string :provider, limit: 128
    end

    add_index :customers, [:email, :phone_number], unique: true
    add_index :customers, [:external_uid, :provider], unique: true
    remove_index :customers, :email
  end
end
