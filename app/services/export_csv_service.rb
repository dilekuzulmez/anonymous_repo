# rubocop:disable all
class ExportCsvService
  require 'csv'

  def initialize(model, excluded = [])
    @model = model
    @excluded = excluded
  end

  def execute
    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      csv << hash_excluded(@model.column_names)

      @model.all.each do |object|
        csv << hash_excluded(object.attributes).values
      end
    end
  end

  # rubocop:disable all
  def export_order_by_match(match_id)
    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      csv << %w[Booking Order_id Order_code First_name Last_name Payment_type Ticket_type Seat Side Unit_price Quantity Amount Discount_code Discount_rate Discount_value Net_revenue
                Payment_status Inv/Sale Source Email Phone_number Address Checked_in Game Start_time Stadium Is_season Bundle Bundle_price 123PAY_Transaction_Id]
      match = Match.find(match_id)
      match.orders.each do |order|
          detail = order.order_details.first
          csv << [
            order.created_at,
            order.id,
            "",
            order.customer.first_name,
            order.customer.last_name,
            order.sale_channel,
            detail.ticket_type.code,
            "","",
            order.is_season ? order.total_before_discount / detail.quantity : detail.unit_price,
            detail.quantity,
            order.is_season ? order.total_before_discount : detail.unit_price * detail.quantity,
            order.promotion_code,
            order.discount_amount,
            order.total_before_discount + order.bundle_additional&.price.to_i - order.total_after_discount,
            order.total_after_discount,
            order.paid? ? "Paid" : "Unpaid",
            order.kind,
            "Ticket app",
            order.customer.email,
            order.customer.phone_number,
            order.shipping_address,
            detail.qr_codes.ticket.all?(&:used),
            match.name,
            match.start_time,
            match.stadium.name,
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
  end

  def export_customer
    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      csv << %w[User_id User_point Spending First_name Last_name Gender DOB District City Email Phone_number Referral_code ]
      CustomerSortService.new.sort_by_spending.each do |customer|
          csv << [
            customer.id,
            customer.point,
            customer.orders.by_paid(true).map(&:total_after_discount).sum,
            customer.first_name,
            customer.last_name,
            customer.gender,
            customer.birthday,
            customer.address.present? ? customer.address['district'] : '',
            customer.address.present? ? customer.address['city'] : '',
            customer.email,
            customer.phone_number,
            customer.referral_code
          ]
      end
    end
  end

  def export_order_by_home_team(team_id, season_id)
    bom = "\uFEFF"
    CSV.generate(bom) do |csv|
      csv << %w[Booking Order_id Order_code First_name Last_name Payment_type Ticket_type Seat Side Unit_price Quantity Amount Discount_code Discount_rate Discount_value Net_revenue
                Payment_status Inv/Sale Source Email Phone_number Address Checked_in Game Start_time Stadium Is_season Bundle Bundle_price Season 123PAY_Transaction_Id]
      home_team = Team.friendly.find(team_id)
      order_ids = Match.where(home_team_id: home_team, season_id: season_id).inject([]) { |rs, obj| rs << obj.orders.ids }.reject(&:empty?).uniq.flatten!
      Order.includes(:customer, :order_details, :bundle_additional).where(id: order_ids).each do |order|
        detail = order.order_details.first
        csv << [
          order.created_at,
          order.id,
          "",
          order.customer.first_name,
          order.customer.last_name,
          order.sale_channel,
          detail.ticket_type.code,
          "","",
          order.is_season ? order.total_before_discount / detail.quantity : detail.unit_price,
          detail.quantity,
          order.is_season ? order.total_before_discount : detail.unit_price * detail.quantity,
          order.promotion_code,
          order.discount_amount,
          order.total_before_discount + order.bundle_additional&.price.to_i - order.total_after_discount,
          order.total_after_discount,
          order.paid? ? "Paid" : "Unpaid",
          order.kind,
          "Ticket app",
          order.customer.email,
          order.customer.phone_number,
          order.shipping_address,
          detail.qr_codes.ticket.all?(&:used),
          detail.match.name,
          detail.match.start_time,
          detail.match.stadium.name,
          order.is_season ? 'YES' : 'NO',
          order.bundle_additional&.code,
          order.bundle_additional&.price,
          detail.match.season.name,
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
  end

  def export_order_by_season(season_id)
    season = Season.find(season_id)
    match_ids = season.matches.ids
    orders = Order.joins(:order_details).where("order_details.match_id IN (?)", match_ids).uniq
    file_name = "#{season.name}_orders_#{Time.current}.csv"
    temp_file = Tempfile.new(file_name)

    attributes = %w[Booking Order_id Order_code First_name Last_name Payment_type Ticket_type Seat Side
                    Unit_price Quantity Amount Discount_code Discount_rate Discount_value Net_revenue
                    Payment_status Inv/Sale Source Email Phone_number Address
                    Checked_in Game Start_time Stadium Is_season Bundle Bundle_price 123PAY_Transaction_Id]

    File.open(temp_file, 'w') do |f|
      bom = "\uFEFF"
      csv_data = CSV.generate(bom) do |csv|
        csv << attributes

        orders.each do |order|
          customer = order.customer
          order_detail = order.order_details.first

          csv << [
            order.created_at,
            order.id,
            '',
            customer&.first_name,
            customer&.last_name,
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
            customer&.email,
            customer&.phone_number,
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

  private

  def hash_excluded(hash = {})
    hash.delete_if { |attr| @excluded.include? attr }
    hash
  end
end
