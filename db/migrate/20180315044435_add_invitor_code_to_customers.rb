class AddInvitorCodeToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :invitor_code, :string
  end
end
