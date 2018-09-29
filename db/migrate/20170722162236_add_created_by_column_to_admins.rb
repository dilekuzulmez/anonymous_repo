class AddCreatedByColumnToAdmins < ActiveRecord::Migration[5.1]
  def change
    add_column :admins, :created_by_id, :integer
    add_foreign_key :admins, :admins, column: :created_by_id, primary_key: :id
    add_index :admins, :created_by_id
  end
end
