require 'zip'

class DownloadPhotosJob < ApplicationJob
  queue_as :default

  def perform(photo_ids, collection_id, user_id, store_id)
    user = User.find(user_id)
    store = Store.find(store_id)
    collection = store.collections.find(collection_id)
    photos = collection.photos.where(id: photo_ids)

    filename = "#{collection.name.parameterize}-#{Time.current.strftime('%Y-%m-%d-%H%M')}.zip"
    zip_path = Rails.root.join("tmp", "downloads", filename)
    FileUtils.mkdir_p(zip_path.dirname)

    Zip::File.open(zip_path, Zip::File::CREATE) do |zip|
      photos.each do |photo|
        entry_path = "#{collection.name.parameterize}/#{photo.image.filename.to_s}"
        zip.get_output_stream(entry_path) { |f| f.write photo.image.download }
      end
    end

    download = UserDownload.create!(
      user: user,
      collection: collection,
      file_path: zip_path.to_s,
      expires_at: 2.hours.from_now
    )
  end
end
