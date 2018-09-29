class AddTicketTypesToPromotion < ActiveRecord::Migration[5.1]
  def change
    add_column :promotions, :ticket_types, :text, array: true, default: []
    add_column :promotions, :start_date, :date
    add_column :promotions, :end_date, :date
  end
end
