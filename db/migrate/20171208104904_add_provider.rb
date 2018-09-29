class AddProvider < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :provider, :integer, null: false
  end
end
