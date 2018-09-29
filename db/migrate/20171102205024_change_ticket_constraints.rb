class ChangeTicketConstraints < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :is_season, :boolean
    change_column :orders, :match_id, :integer, null: true
    add_reference :order_details, :match, index: true, foreign_key: true, null: true
  end
end
