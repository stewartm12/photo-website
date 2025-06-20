class GalleriesController < ApplicationController
  include Pagy::Backend

  before_action :set_gallery, only: %i[edit update destroy]

  def index
    @pagy, @galleries = pagy(filtered_galleries)
  end

  def new
    @gallery = Current.store.galleries.new
  end

  def create
    @gallery = Current.store.galleries.new(gallery_params)
    photo_param = gallery_params.dig(:photo_attributes, :image)

    unless photo_param.present?
      flash.now[:alert] = 'Please upload an image.' and return
    end

    @gallery.build_photo_from_image(photo_param, store_slug: Current.store.slug)

    if @gallery.save
      redirect_to store_galleries_path(Current.store), success: 'Gallery created successfully.'
    else
      flash.now[:alert] = @gallery.errors.full_messages.join(', ')
    end
  end

  def edit; end

  def update
    if (image_param = gallery_params.dig(:photo_attributes, :image))

      @gallery.update_photo_image(image_param, store_slug: Current.store.slug)
    end

    if @gallery.update(gallery_params.except(:photo_attributes))
      redirect_to store_galleries_path(Current.store), success: 'Gallery updated successfully.'
    else
      flash.now[:alert] = @gallery.errors.full_messages.join(', ')
    end
  end

  def destroy
    @gallery.destroy
    flash.now[:success] = 'Gallery deleted!'
    @pagy, @galleries = pagy(filtered_galleries)
  end

  private

  def set_gallery
    @gallery = Current.store.galleries.find_by(id: params[:id])
  end

  def gallery_params
    params.expect(gallery: [:name, :description, :active, photo_attributes: %i[image]])
  end

  def search_params
    params.permit(:name, :status, :sort, :order)
  end

  def filtered_galleries
    Current.store.galleries.includes(:collections, photo: { image_attachment: [blob: { variant_records: :blob }] })
         .then { |g| search_params[:name].present? ? g.where('name ILIKE ?', "%#{search_params[:name]}%") : g }
         .then { |g| search_params[:status].present? ? g.where(active: search_params[:status]) : g }
         .then { |g| g.order(safe_sort_order) }
  end

  def safe_sort_order
    allowed_columns = %w[name updated_at]
    allowed_directions = %w[asc desc]

    column = search_params[:sort]
    direction = search_params[:order]

    column = allowed_columns.include?(column) ? column : 'name'
    direction = allowed_directions.include?(direction) ? direction : 'asc'

    { column => direction.to_sym }
  end
end
