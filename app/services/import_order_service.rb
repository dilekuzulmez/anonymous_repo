class ImportOrderService
  def execute(file, triggered_user)
    return 'Please select template file to import' if file.nil?

    uploaded_file = S3_BUCKET.object('imports/' + File.basename(file.tempfile))

    if uploaded_file.upload_file(file.tempfile)
      key = uploaded_file.key
      ImportOrderJob.perform_later(key, triggered_user)

      message = 'Orders are queued to be import'
    else
      message = 'Error in uploading.'
    end

    message
  end
end
