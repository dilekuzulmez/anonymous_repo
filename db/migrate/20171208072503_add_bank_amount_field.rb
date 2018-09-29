class AddBankAmountField < ActiveRecord::Migration[5.1]
  def change
    add_column :transaction_histories, :opamount, :decimal, :default => 0.0
    add_column :transaction_histories, :discount_amount_123, :decimal, :default => 0.0
  end
end
