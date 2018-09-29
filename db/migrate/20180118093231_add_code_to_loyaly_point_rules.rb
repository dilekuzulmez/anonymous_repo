class AddCodeToLoyalyPointRules < ActiveRecord::Migration[5.1]
  def change
    add_column :loyalty_point_rules, :code, :string
  end
end
