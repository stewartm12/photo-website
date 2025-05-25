module ActiveStorageHelper
  def create_blob(filename, content_type)
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join('spec/fixtures/files', filename)),
      filename: filename,
      content_type: content_type
    )
  end
end
