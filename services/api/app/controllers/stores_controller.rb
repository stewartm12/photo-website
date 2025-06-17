class StoresController < ApplicationController
  def index
    @stores = Current.user.stores
  end

  def show
    @total_galleries = Current.store.galleries_count
    @total_collections = Current.store.collections.count
    @total_appointments = Current.store.appointments.count
    @total_customers = Current.store.customers.count
    @total_photos = Photo.joins('INNER JOIN collections ON collections.id = photos.imageable_id')
                    .joins('INNER JOIN galleries ON galleries.id = collections.gallery_id')
                    .where(photos: { imageable_type: 'Collection' }, galleries: { store_id: Current.store.id })
                    .count

    @recent_galleries = Current.store.galleries.order(id: :desc).limit(5)
    @upcoming_appointments = Current.store.appointments.includes(:customer, :appointment_package).where(status: :pending).order(preferred_date_time: :desc).limit(5)
    @newest_customers = Current.store.customers.order(id: :desc).limit(3)
  end

  def new
    @store = Store.new
  end

  def create
    @store = Store.new(create_params.except(:photo))
    @store.owner = Current.user

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

  def edit
    @store = Store.find_by(slug: params[:store_slug])
  end

  def update
    @store = Store.find_by(slug: params[:store_slug])

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
    params.expect(store: [:name, :domain, :email, photo: [:image]])
  end

  def update_params
    params.expect(store: [:email, photo: [:image]])
  end
end
