class UploadProfileImageService
  def execute(file, identifier)
    return if file.nil?

    uploaded_file = S3_BUCKET.object('profile_images/' + identifier.id.to_s + '/' + identifier.updated_at.to_s)

    return uploaded_file.public_url if uploaded_file.upload_file(file.tempfile)
  end
end
