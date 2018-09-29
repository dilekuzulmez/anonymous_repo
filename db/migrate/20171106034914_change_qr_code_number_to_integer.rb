class ChangeQrCodeNumberToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :qr_codes, :number, 'integer USING CAST(number AS integer)'
  end
end
