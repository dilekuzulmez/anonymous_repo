class AddProjectCommissionToOrder < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :project_type, :string
    add_column :orders, :commission_rate, :float
  end
end
