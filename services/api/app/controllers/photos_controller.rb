require 'zip'

class PhotosController < ApplicationController
  before_action :set_collection, only: %i[new create download bulk_delete]

  def new
    @photo = @collection.photos.new
  end

  def create
    photo_params.each do |signed_id|
      blob = ActiveStorage::Blob.find_signed(signed_id)
      @collection.build_photo_from_image(blob, store_slug: Current.store)
    end

    @collection.photos_changed = true

    if @collection.save
      redirect_to store_gallery_collection_path(Current.store, gallery, @collection), success: 'Photo(s) uploaded successfully to collection'
    else
      redirect_to store_gallery_collection_path(Current.store, gallery, @collection), alert: @collection.errors.full_messages.to_sentence
    end
  end

  def download
    photo_ids = params[:photo_ids]
    photos = Photo.where(id: photo_ids)

    zip_data = Zip::OutputStream.write_buffer do |zip|
      photos.each do |photo|
        filename = photo.image.filename.to_s
        file_data = photo.image.download

        zip.put_next_entry(filename)
        zip.write(file_data)
      end
    end

    zip_data.rewind
    send_data zip_data.read, type: 'application/zip', filename: "#{@collection.name}-#{Time.current.strftime('%Y-%m-%d-%H%M')}.zip"
  end

  def bulk_delete
    @deleted_ids = delete_params[:photo_ids]
    @collection.photos.where(id: @deleted_ids).destroy_all
    @collection.update(photos_count: @collection.photos.count)
    flash.now[:success] = 'Photo(s) deleted successfully from collection'
  end

  private

  def photo_params
    pp = params.expect(photo: [images: []])
    cleaned_images = pp[:images].reject(&:blank?)
    cleaned_images
  end

  def delete_params
    params.permit(:gallery_id, :collection_id, photo_ids: [])
  end

  def set_collection
    @collection = gallery.collections.find_by(id: params[:collection_id])
  end

  def gallery
    @gallery ||= Current.store.galleries.find_by(id: params[:gallery_id])
  end
end
