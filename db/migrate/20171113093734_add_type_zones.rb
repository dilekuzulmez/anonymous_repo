class AddTypeZones < ActiveRecord::Migration[5.1]
  def up
    add_column :zones, :zone_type, :integer, null: false, default: 0
  end

  def down
    remove_column :zones, :zone_type
  end
end
