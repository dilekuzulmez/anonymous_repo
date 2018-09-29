class AddFirebaseTokenToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :push_token, :string
    # force relogin to update push token
    Customer.all.update_all(access_token: nil)
  end
end
