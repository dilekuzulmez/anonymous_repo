class AddEmployeeTokenToAdmin < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :employee_token, :string
    add_column :admins, :token_expire, :datetime
  end
end
