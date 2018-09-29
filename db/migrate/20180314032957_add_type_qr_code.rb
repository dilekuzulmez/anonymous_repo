class AddTypeQrCode < ActiveRecord::Migration[5.1]
  def up
    add_column :qr_codes, :qr_type, :integer
  end

  def down
    add_column :qr_codes, :qr_type
  end
end
