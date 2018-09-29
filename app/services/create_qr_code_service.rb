class CreateQrCodeService
  require 'rqrcode'
  include OrderQrUtils

  # rubocop:disable Metrics/MethodLength
  def create_qr_code(detail)
    @detail = detail
    hash_key = rand(10000..99999)
    qr_code = generate_qr_code(hash_key)
    @detail.update(hash_key: hash_key, qr_code_file_name: qr_code)
  end

  def generate_qr_code(hash_key)
    qr_code = temp_file(@detail.id, hash_key)
    RQRCode::QRCode.new(qr_info(hash_key)).as_png(
      fill: 'white',
      color: 'black',
      size: 300,
      module_px_size: 2,
      file: qr_code
    )
    qr_code.split("public")[1]
  end

  private_class_method

  def save_order_qr_code(hash_key, output, expired_at, index = 0)
    @qr = QrCode.new(
      order_detail_id: @detail.id,
      number: index,
      image: File.open(output),
      hash_key: hash_key,
      qr_type: 'payment',
      expired_at: expired_at
    )
    if @qr.save
      @qr.image.url
    elsif File.exist?(output)
      File.delete(output)
    end
  end

  def save_ticket_qr_code(hash_key, expired_time, index = 0)
    @qr = QrCode.new(
      order_detail_id: @detail.id,
      number: index,
      qr_type: 'ticket',
      hash_key: hash_key,
      match_id: @detail.match&.id,
      customer_id: @detail.order.customer_id,
      expired_at: expired_time
    ).save
  end

  def qr_info(hash_key)
    "#{hash_key}"
  end
end
