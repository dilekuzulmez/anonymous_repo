class AddReferralToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :referral_code, :string
    add_index :customers, :referral_code, unique: true
  end
end
