class AddImageToZones < ActiveRecord::Migration[5.1]
  def change
    add_attachment :zones, :image
  end
end
