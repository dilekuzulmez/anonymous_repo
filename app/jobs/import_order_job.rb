class ImportOrderJob < ApplicationJob
  include OrderImportHelper
  CHUNK_SIZE = 150
  queue_as :import

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def perform(bucket_key, triggered_user)
    logger.info "Processing job for #{triggered_user.name}"

    transaction_error = nil

    Order.transaction do
      SmarterCSV.process(StringIO.new(S3_BUCKET.object(bucket_key).get.body.read), csv_options) do |chunk|
        chunk.each do |row|
          logger.info "processing #{row}"
          Audited.audit_class.as_user(triggered_user) do
            @stadium = stadium_from_csv row
            @zone = zone_from_csv(row, @stadium)
            @match = match_from_csv(row, @stadium)
            @promo = promo_from_csv row
            create_promotion_for_match(@promo, @match)

            @ticket_type = ticket_type_from_csv(@zone, @match)

            order = new_order_from_csv_row(row)
            begin
              unless order.save
                logger.info "import order failed: #{order.errors.full_messages}"
                transaction_error = error_message(row, order)
                raise ActiveRecord::Rollback
              end
            rescue StandardError => e
              logger.info "import order failed: #{e.message}"
              transaction_error = "Row: #{row}. Error: #{e.message}"
              raise ActiveRecord::Rollback
            end
            order.calculate_expired_at
          end
        end
      end
    end
    # rubocop:enable

    if transaction_error
      Notification.create!(kind: :danger, message: transaction_error, admin: triggered_user)
    else
      Notification.create!(kind: :success, message: 'Import customers successfully', admin: triggered_user)
    end
  end

  private

  def error_message(row, customer)
    "Row: #{row}. Error: #{customer.errors.full_messages.join(', ')}"
  end

  def csv_options
    {
      chunk_size: CHUNK_SIZE
    }
  end

  def new_order_from_csv_row(row)
    Order.where(order_code: row[:order_code]).first_or_initialize(order_hash(row))
  end

  def order_hash(row)
    {
      customer: customer_from_csv(row), kind: 'sell', order_code: row[:order_code],
      paid: 'paid'.casecmp(row[:payment_status]), commission_rate: commission_rate(row),
      purchased_date: (DateTime.yesterday if 'paid'.casecmp(row[:payment_status])),
      payment_type: (row[:payment_type] unless row[:payment_type].nil?),
      sale_channel: (row[:sale_channels] unless row[:sale_channels].nil?),
      order_details: [new_order_detail_from_csv(row)],
      promotion_code: (row[:discount_code] unless row[:discount_code].nil?),
      discount_type: 'percent', project_type: (row[:project] unless row[:project].nil?)
    }
  end

  def new_order_detail_from_csv(row)
    OrderDetail.new(ticket_type_id: @ticket_type&.id, quantity: 1, unit_price: row[:ticket_price],
                    match_id: @match&.id)
  rescue StandardError => _
    ''
  end

  def create_promotion_for_match(promotion, match)
    MatchsPromotion.create(promotion: promotion, match: match) if promotion
  end
end
