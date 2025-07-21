require 'zip'

class PhotosController < ApplicationController
  before_action :set_collection, only: %i[new create download bulk_delete]

  def new
    @photo = @collection.photos.new
  end

  def create
    ProcessUploadedPhotosJob.perform_later(@collection.id, photo_params, Current.store.slug)

    redirect_to store_gallery_collection_path(Current.store, gallery, @collection), success: 'Your photos are being uploaded.'
  end

  def update
    @photo = Photo.find(update_params[:id])
    @photo.insert_at(update_params[:position].to_i)

    head :no_content
  end

  def download
    photo_ids = params[:photo_ids]
    photos = Photo.where(id: photo_ids)

    DownloadPhotosJob.perform_later(photo_ids, @collection.id, Current.user.id, Current.store.id)

    head :ok
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

  def update_params
    params.permit(:id, :position)
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
