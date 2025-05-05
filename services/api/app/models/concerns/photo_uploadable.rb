module PhotoUploadable
  extend ActiveSupport::Concern

  def build_photo_from_image(uploaded_file, store_slug:)
    file_key = generate_file_key(uploaded_file.original_filename, store_slug)
    alt_text = generate_alt_text(uploaded_file.original_filename)

    build_photo(file_key: file_key, alt_text: alt_text)

    attach_uploaded_file(uploaded_file, file_key)
  end

  def update_photo_image(uploaded_file, store_slug:)
    file_key = generate_file_key(uploaded_file.original_filename, store_slug)
    alt_text = generate_alt_text(uploaded_file.original_filename)

    attach_uploaded_file(uploaded_file, file_key)

    photo.update!(file_key: file_key, alt_text: alt_text)
  end

  private

  def attach_uploaded_file(uploaded_file, file_key)
    photo.image.attach(
      io: uploaded_file.tempfile,
      filename: uploaded_file.original_filename,
      content_type: uploaded_file.content_type,
      key: file_key
    )
  end

  def generate_file_key(filename, store_slug)
    "#{store_slug}/#{filename}"
  end

  def generate_alt_text(filename)
    filename.sub(/\.[a-zA-Z]+\z/, '').tr('-', ' ') + ' alt text'
  end
end
