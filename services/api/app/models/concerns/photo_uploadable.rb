module PhotoUploadable
  extend ActiveSupport::Concern

  def build_photo_from_image(uploaded_file, store_slug:, section_key: nil, positioned: nil)
    file_name = filename_from_upload(uploaded_file)
    file_key = generate_file_key(file_name, store_slug)
    alt_text = generate_alt_text(file_name)
    position = positioned ? self.photos_count + 1 : nil

    if respond_to?(:photo) && respond_to?(:build_photo)
      build_photo(file_key: file_key, alt_text: alt_text)
      attach_uploaded_file(uploaded_file, file_key)
    elsif respond_to?(:photos)
      new_photo = photos.build(file_key: file_key, alt_text: alt_text, section_key: section_key, position: position)
      new_photo.image.attach(uploaded_file)
    end
  end

  def update_photo_image(uploaded_file, store_slug:)
    file_name = filename_from_upload(uploaded_file)
    file_key = generate_file_key(file_name, store_slug)
    alt_text = generate_alt_text(file_name)

    attach_uploaded_file(uploaded_file, file_key)

    photo.update!(file_key: file_key, alt_text: alt_text)
  end

  private

  def filename_from_upload(uploaded_file)
    if uploaded_file.respond_to?(:original_filename)
      uploaded_file.original_filename
    else
      uploaded_file.filename.to_s
    end
  end

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
