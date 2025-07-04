class ProcessUploadedPhotosJob < ApplicationJob
  queue_as :default

  def perform(collection_id, signed_ids, store_slug)
    store = Store.find_by(slug: store_slug)
    collection = store.collections.find(collection_id)

    signed_ids.each_with_index do |signed_id, index|
      blob = ActiveStorage::Blob.find_signed(signed_id)
      collection.build_photo_from_image(blob, store_slug: store_slug)
    end

    collection.photos_changed = true
    collection.save!
  end
end
