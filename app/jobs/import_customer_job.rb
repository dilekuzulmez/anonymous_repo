class ImportCustomerJob < ApplicationJob
  CHUNK_SIZE = 100

  queue_as :import

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def perform(bucket_key, triggered_user)
    logger.info "Processing job for #{triggered_user.name}"

    transaction_error = nil

    SmarterCSV.process(StringIO.new(S3_BUCKET.object(bucket_key).get.body.read), csv_options) do |chunk|
      chunk.each do |row|
        logger.info "processing #{row}"
        Audited.audit_class.as_user(triggered_user) do
          customer = new_customer_from_csv_row(row)

          unless customer.save
            logger.info "import match failed: #{customer.errors.full_messages}"
            transaction_error = error_message(row, customer)
          end
        end
      end
    end

    if transaction_error
      Notification.create!(kind: :danger, message: transaction_error, admin: triggered_user)
    else
      Notification.create!(kind: :success, message: 'Import customers successfully', admin: triggered_user)
    end
  end
  # rubocop:enable

  private

  def error_message(row, customer)
    "Row: #{row}. Error: #{customer.errors.full_messages.join(', ')}"
  end

  def csv_options
    {
      chunk_size: CHUNK_SIZE
    }
  end

  def new_customer_from_csv_row(row)
    Customer.new(
      email: row[:email],
      first_name: row[:first_name],
      last_name: row[:last_name],
      phone_number: row[:phone_number],
      gender: row[:gender].downcase,
      address: { city: row[:city], district: row[:district] },
      birthday: DateTime.parse(row[:dob])
    )
  end
end
