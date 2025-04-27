class StoresController < ApplicationController
  def index
    @stores = Current.user.stores
  end

  def show
    @store = Store.find_by(slug: params[:store_slug])
    @galleries = @store.galleries
    @collections = @store.collections
    @appointments = @store.appointments
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
    params.expect(store: %i[name domain])
  end
end
