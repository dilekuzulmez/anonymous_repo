module OrderQrUtils
  UPLOAD_DIR = 'public/uploads/qr_codes/'.freeze
  def temp_file(detail_id, hash_key)
    ensure_dir_exist
    "public/uploads/qr_codes/qr_#{detail_id}_#{hash_key}.png"
  end

  private

  def ensure_dir_exist
    dir = "#{Rails.root}/#{UPLOAD_DIR}"
    FileUtils.mkdir_p(dir)
  end
end
