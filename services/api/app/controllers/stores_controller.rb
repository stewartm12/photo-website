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
    @store = Store.new(store_params)
    @store.owner = Current.user

    ActiveRecord::Base.transaction do
      @store.save!
      StoreMembership.create!(user: Current.user, store: @store)
    end

    redirect_to stores_path, success: 'Store created successfully'
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:alert] = e.record.errors.full_messages.join("\n ")
  end

  def edit; end

  def update; end

  private

  def store_params
    params.expect(store: %i[name domain email])
  end
end
