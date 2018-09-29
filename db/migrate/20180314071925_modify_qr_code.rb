class ModifyQrCode < ActiveRecord::Migration[5.1]
  def up
    add_column :qr_codes, :hash_key, :string
    add_reference :qr_codes, :match, index: true
    add_reference :qr_codes, :customer, index: true
  end

  def down
    remove_column :qr_codes, :hash_key, :string
    remove_column :qr_codes, :match_id
    remove_column :qr_codes, :customer_id
  end
end
