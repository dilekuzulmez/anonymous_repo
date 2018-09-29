class AddQrImageToOrderDetail < ActiveRecord::Migration[5.1]
  def up
    add_attachment :order_details, :qr_code
  end

  def down
    remove_attachment :order_details, :qr_code
  end
end
