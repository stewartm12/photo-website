class CollectionsController < ApplicationController
  include Pagy::Backend

  before_action :set_collection, only: %i[edit update destroy]

  def index
    load_collections
  end

  def show
    @collection = gallery.collections.includes(photos: { image_attachment: :blob }).find_by(id: params[:id])
  end

  def new
    @collection = gallery.collections.new
  end

  def create
    @collection = gallery.collections.new(collection_params)

    if @collection.save
      flash.now[:success] = 'Collection created successfully.'
      load_collections
    else
      flash.now[:alert] = @collection.errors.full_messages.join(', ')
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to store_gallery_collections_path(Current.store, gallery) }
    end
  end

  def edit; end

  def update
    if @collection.update(collection_params)
      flash.now[:success] = 'Collection updated successfully.'
      load_collections
    else
      flash.now[:alert] = @collection.errors.full_messages.join(', ')
    end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to store_gallery_collections_path(Current.store, gallery) }
    end
  end

  def destroy
    @collection.destroy
    flash.now[:success] = 'Collection deleted!'
    load_collections

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to store_gallery_collections_path(Current.store, gallery) }
    end
  end

  private

  def set_collection
    @collection = gallery.collections.find_by(id: params[:id])
  end

  def gallery
    @gallery ||= Current.store.galleries.find_by(id: params[:gallery_id])
  end

  def search_params
    params.permit(:name, :sort, :order)
  end

  def collection_params
    params.expect(collection: %i[name shoot_date])
  end

  def load_collections
    @pagy, @collections = pagy(filtered_collections)
  end

  def filtered_collections
    collections = gallery.collections

    if search_params[:name].present?
      collections = collections.where('collections.name ILIKE :q', q: "%#{search_params[:name]}%")
    end

    sort_column = %w[id name shoot_date created_at].include?(search_params[:sort]) ? search_params[:sort] : 'id'
    sort_direction = %w[asc desc].include?(search_params[:order]) ? search_params[:order] : 'desc'

    collections.order("#{sort_column} #{sort_direction}")
  end
end
