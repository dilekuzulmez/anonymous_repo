class CreateTransactionHistories < ActiveRecord::Migration[5.1]
  def change
    create_table :transaction_histories do |t|
      t.belongs_to :order, index: true, foreign_key: true
      t.belongs_to :customer, index: true, foreign_key: true
      t.string :request_ip, null: false
      t.string :key, null: false
      t.integer :status, null: false
      t.money :amount, null: false
      t.hstore :response
      t.timestamps
    end
  end
end
