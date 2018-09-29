class RemoveCustomerColumns < ActiveRecord::Migration[5.1]
  def change
    remove_column :customers, :external_uid
    remove_column :customers, :provider
  end
end
