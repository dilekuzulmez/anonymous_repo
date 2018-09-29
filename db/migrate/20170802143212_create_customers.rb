class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :email, null: false
      t.index :email, unique: true
      t.string :first_name, null: false
      t.string :last_name
      t.string :gender, limit: 32
      t.date :birthday
      t.string :district, limit: 32
      t.string :city, limit: 32
      t.string :phone_number, limit: 32

      t.timestamps
    end
  end
end
