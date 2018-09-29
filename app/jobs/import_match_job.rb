class ImportMatchJob < ApplicationJob
  CHUNK_SIZE = 100

  queue_as :import

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def perform(bucket_key, triggered_user)
    logger.info "Processing job for #{triggered_user.name}"

    transaction_error = nil

    Match.transaction do
      SmarterCSV.process(StringIO.new(S3_BUCKET.object(bucket_key).get.body.read), csv_options) do |chunk|
        chunk.each do |row|
          logger.info "processing #{row}"
          Audited.audit_class.as_user(triggered_user) do
            match = new_match_from_csv_row(row)

            unless match.persisted?
              logger.info "import match failed: #{match.errors.full_messages}"
              transaction_error = error_message(row, match)
              raise ActiveRecord::Rollback
            end
          end
        end
      end
    end

    if transaction_error
      Notification.create!(kind: :danger, message: transaction_error, admin: triggered_user)
    else
      Notification.create!(kind: :success, message: 'Import matches successfully', admin: triggered_user)
    end
  end
  # rubocop:enable

  private

  def error_message(row, match)
    "Row: #{row}. Error: #{match.errors.full_messages.join(', ')}"
  end

  def csv_options
    {
      chunk_size: CHUNK_SIZE,
      value_converters: { date: CsvDatetimeConverterService }
    }
  end

  def new_match_from_csv_row(row)
    create_match_service ||= CreateMatchService.new
    match_params = {
      name: row[:match],
      start_time: row[:date],
      home_team: Team.find_by(name: row[:home_team]),
      away_team: Team.find_by(name: row[:away_team]),
      stadium: Stadium.find_by(name: row[:venue]),
      season: Season.find_by(name: row[:season])
    }
    create_match_service.execute(match_params)
  end
end
