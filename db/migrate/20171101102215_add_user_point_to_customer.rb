class AddUserPointToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :point, :integer, default: 0
  end
end
