class ImportService
  def execute(file, triggered_user)
    return 'Please select template file to import' if file.nil?

    uploaded_file = S3_BUCKET.object('imports/' + File.basename(file.tempfile))

    if uploaded_file.upload_file(file.tempfile)
      ImportMatchJob.perform_later(uploaded_file.key, triggered_user)
      message = 'Records are queued to be import'
    else
      message = 'Error in uploading.'
    end

    message
  end
end
