class CreateRefQrJob < ApplicationJob
  require 'rqrcode'
  require 'zip'
  include OrderQrUtils
  queue_as :default

  # rubocop:disable all
  def perform(qr_quantity, channel, ticket_type, home_team_id)
    team_name = Team.find_by(id: home_team_id).name || 'Unknown'
    file_name = "#{qr_quantity}-#{team_name}-#{ticket_type}.zip"
    compressed_file = "#{Rails.root.join('tmp', file_name)}".to_s
    files_list = []

    qr_quantity.to_i.times do |i|
      hash_key = SecureRandom.hex(10)
      output = generate_qr_code(hash_key, i, channel)
      ref_ticket_save(hash_key, output, Time.current + 1.year, ticket_type, channel, home_team_id)
      files_list << output
    end

    Zip::OutputStream.open(compressed_file) do |zos|
      files_list.each do |file|
        zos.put_next_entry(file)
        zos.print IO.read(file)
      end
    end

    uploaded_file = S3_BUCKET.object('reference_qr' + file_name)
    if uploaded_file.upload_file(compressed_file)
      CsvFile.create name: file_name, url: uploaded_file.public_url
      csv_files = CsvFile.order(:id)
      csv_files.first.destroy if csv_files.count > 10
    end

    File.delete(compressed_file)
  end

  private

  def generate_qr_code(hash_key, i, channel)
    output = hash_key_file(hash_key)
    RQRCode::QRCode.new(qr_info(hash_key, i, channel)).as_png(
      fill: 'white',
      color: 'black',
      size: 300,
      module_px_size: 2,
      file: output
    )
    output
  end

  # rubocop:disable all
  def ref_ticket_save(hash_key, output, expired_time, ticket_type, channel, home_team_id)
    @qr = QrCode.new(
      home_team_id: home_team_id,
      ticket_type: ticket_type,
      channel: channel,
      qr_type: 'ticket',
      hash_key: hash_key,
      image: File.open(output),
      expired_at: expired_time
    ).save
  end

  def qr_info(hash_key, index, channel)
    {
      number: index,
      hash_key: hash_key,
      channel: channel
    }.to_json
  end
end
