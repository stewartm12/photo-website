require 'zip'

class DownloadPhotosJob < ApplicationJob
  queue_as :default

  def perform(photo_ids, collection_id, user_id, store_id)
    user = User.find(user_id)
    store = Store.find(store_id)
    collection = store.collections.find(collection_id)
    photos = collection.photos.where(id: photo_ids)

    filename = "#{collection.name.parameterize}-#{Time.current.strftime('%Y-%m-%d-%H%M')}.zip"
    tmp_path = Rails.root.join('tmp', 'downloads', filename)
    FileUtils.mkdir_p(tmp_path.dirname)

    Zip::File.open(tmp_path, Zip::File::CREATE) do |zip|
      photos.each do |photo|
        entry_path = "#{collection.name.parameterize}/#{photo.image.filename.to_s}"
        zip.get_output_stream(entry_path) { |f| f.write photo.image.download }
      end
    end

    download = UserDownload.create!(user: user, collection: collection, expires_at: 1.day.from_now)
    download.zip_file.attach( io: File.open(tmp_path), filename: filename, content_type: 'application/zip')

    File.delete(tmp_path) if File.exist?(tmp_path)
  end
end
