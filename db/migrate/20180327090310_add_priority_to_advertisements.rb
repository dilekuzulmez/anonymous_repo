class AddPriorityToAdvertisements < ActiveRecord::Migration[5.1]
  def change
    add_column :advertisements, :priority, :boolean, default: false
  end
end
