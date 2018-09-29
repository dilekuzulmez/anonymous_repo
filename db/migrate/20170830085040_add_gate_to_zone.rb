class AddGateToZone < ActiveRecord::Migration[5.1]
  def change
    add_reference :zones, :gate, index: true, foreign_key: true
  end
end
