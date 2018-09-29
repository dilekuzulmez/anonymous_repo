class ExportOrderJob < ApplicationJob
  queue_as :default

  def perform
    generate_data
  end

  private

  # rubocop:disable all
  def generate_data
    file_name = "orders_#{Time.now.to_i}.csv"
    temp_file = Tempfile.new(file_name)

    attributes = %w[Booking Order_id Order_code First_name Last_name Payment_type Ticket_type Seat Side
                    Unit_price Quantity Amount Discount_code Discount_rate Discount_value Net_revenue
                    Payment_status Inv/Sale Source Email Phone_number Address
                    Checked_in Game Start_time Stadium Is_season Bundle Bundle_price 123PAY_Transaction_Id]

    File.open(temp_file, 'w') do |f|
      bom = "\uFEFF"
      csv_data = CSV.generate(bom) do |csv|
        csv << attributes

        orders = Order.includes(:customer, :order_details).order(id: :desc)
        orders.each do |order|
          customer = order.customer
          order_detail = order.order_details.first

          csv << [
            order.created_at,
            order.id,
            '',
            customer.first_name,
            customer.last_name,
            order.sale_channel,
            order_detail.ticket_type.code,
            '', '',
            order.is_season ? order.total_before_discount / order_detail.quantity : order_detail.unit_price,
            order_detail.quantity,
            order.is_season ? order.total_before_discount : order_detail.unit_price * order_detail.quantity,
            order.promotion_code,
            order.discount_amount,
            order.total_before_discount + order.bundle_additional&.price.to_i - order.total_after_discount,
            order.total_after_discount,
            order.paid? ? 'Paid' : 'Unpaid',
            order.kind,
            'Ticket app',
            customer.email,
            customer.phone_number,
            order.shipping_address,
            order_detail.qr_codes.ticket.all?(&:used),
            order_detail.match.name,
            order_detail.match.start_time,
            order_detail.match.stadium.name,
            order.is_season ? 'YES' : 'NO',
            order.bundle_additional&.code,
            order.bundle_additional&.price,
            if order.transaction_history&.response.present?
              if order.transaction_history&.response.dig('123PAYtransactionId').present?
                order.transaction_history&.response.dig('123PAYtransactionId')
              else
                order.transaction_history&.response.dig('mTransactionID')
              end
            end
          ]
        end
      end
      f.write(csv_data)
    end

    uploaded_file = S3_BUCKET.object('orders/' + file_name)
    if uploaded_file.upload_file(temp_file)
      CsvFile.create name: file_name, url: uploaded_file.public_url
      csv_files = CsvFile.order(:id)
      csv_files.first.destroy if csv_files.count > 10
    end
  end
end
