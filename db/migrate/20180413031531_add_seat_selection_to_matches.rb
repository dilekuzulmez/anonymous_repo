class AddSeatSelectionToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :seat_selection, :boolean, default: false
  end
end
