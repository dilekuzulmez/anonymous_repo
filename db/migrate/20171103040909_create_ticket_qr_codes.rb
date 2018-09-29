class CreateTicketQrCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :qr_codes do |t|
      t.string :number
      t.boolean :used, default: false
      t.attachment :image
      t.belongs_to :order_detail, index: true, foreign_key: true
    end

    remove_attachment :order_details, :qr_code
    remove_column :order_details, :check_in_time

    OrderDetail.all.each do |detail|
      detail.generate_qr
    end
  end
end
