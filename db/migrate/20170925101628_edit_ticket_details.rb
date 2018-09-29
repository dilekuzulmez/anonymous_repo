class EditTicketDetails < ActiveRecord::Migration[5.1]
  def change
    remove_column :ticket_types, :description
    add_column :ticket_types, :benefit, :text
  end
end
