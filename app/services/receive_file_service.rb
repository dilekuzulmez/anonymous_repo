class ReceiveFileService
  UPLOAD_DIR = 'tmp/upload'.freeze

  def execute(uploaded_file)
    ensure_dir_exist

    move_to_new_place(uploaded_file)
  end

  private

  def ensure_dir_exist
    dir = "#{Rails.root}/#{UPLOAD_DIR}"
    FileUtils.mkdir_p(dir)
  end

  def move_to_new_place(uploaded_file)
    tempfile = uploaded_file.tempfile
    new_file = "#{Rails.root}/#{UPLOAD_DIR}/#{Time.now.to_i}"
    FileUtils.cp(tempfile.path, new_file)

    new_file
  end
end
