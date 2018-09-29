class AddClassToTicketType < ActiveRecord::Migration[5.1]
  def self.up
    change_table :ticket_types do |t|
      t.integer :class_type, null: false, default: 0
    end
  end

  def self.down
    remove_column :ticket_types, :class_type
  end
end
