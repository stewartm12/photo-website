class StoresController < ApplicationController
  before_action :set_store, only: %i[edit update]

  def index
    @stores = Current.user.stores.includes(photo: { image_attachment: :blob }).order(created_at: :desc)
  end

  def show
    @total_galleries = Current.store.galleries_count
    @total_collections = Current.store.collections.count
    @total_appointments = Current.store.appointments.count
    @total_customers = Current.store.customers.count
    @recent_galleries = Current.store.galleries.order(id: :desc).limit(5)
    @newest_customers = Current.store.customers.order(id: :desc).limit(3)
    @upcoming_appointments = Current.store.appointments.includes(:customer, :appointment_package).where(status: :pending).order(preferred_date_time: :desc).limit(5)
    @total_photos = photos_for_store.count
    gallery_ids = @recent_galleries.map(&:id)

    @photo_counts_by_gallery = photos_for_store
      .where(collections: { gallery_id: gallery_ids })
      .group('collections.gallery_id')
      .count
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(create_params.except(:photo).merge(owner: Current.user))

    ActiveRecord::Base.transaction do
      if (photo_param = create_params.dig(:photo, :image))
        @store.build_photo_from_image(photo_param, store_slug: @store.slug)
      end

      @store.save!
      StoreMembership.create!(user: Current.user, store: @store)
    end

    flash.now[:success] = 'Store created successfully'
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.record.errors.full_messages.to_sentence
  end

  def edit; end

  def update
    if (photo_param = update_params.dig(:photo, :image))
      @store.update_photo_image(photo_param, store_slug: @store.slug)
    end

    if @store.update(update_params.except(:photo))
      flash.now[:success] = 'Store updated successfully.'
    else
      flash.now[:alert] = @store.errors.full_messages.to_sentence
    end
  end

  private

  def create_params
    params.expect(store: [:name, :domain, :email, :time_zone, photo: [:image]])
  end

  def update_params
    params.expect(store: [:email, :time_zone, photo: [:image]])
  end

  def set_store
    @store = Current.store
  end

  def photos_for_store
    Photo
      .joins('INNER JOIN collections ON collections.id = photos.imageable_id')
      .joins('INNER JOIN galleries ON galleries.id = collections.gallery_id')
      .where(photos: { imageable_type: 'Collection' }, galleries: { store_id: Current.store.id })
  end
end
