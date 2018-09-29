class AddActiveToMatch < ActiveRecord::Migration[5.1]
  def up
    add_column :matches, :active, :boolean, default: true
  end

  def down
    remove_column :matches, :active
  end
end
