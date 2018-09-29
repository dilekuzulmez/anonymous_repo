class AddColumnsToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :facebook_uid, :string
    add_column :customers, :access_token, :string
    add_column :customers, :profile_picture_url, :string
    add_index :customers, :access_token, unique: true
    add_index :customers, :facebook_uid, unique: true
  end
end
