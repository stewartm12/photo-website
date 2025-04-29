class GalleriesController < ApplicationController
  include Pagy::Backend

  def index
    @pagy, @galleries = pagy(filtered_galleries)
  end

  def show; end

  def edit; end

  def destroy
    @gallery = store.galleries.find_by(id: params[:id])
    @gallery.destroy
  end

  private

  def store
    @store ||= Store.find_by(slug: params[:store_slug])
  end

  def search_params
    params.permit(:name, :status, :sort, :order)
  end

  def filtered_galleries
    store.galleries
         .includes(collections: :photos)
         .then { |g| search_params[:name].present? ? g.where('name ILIKE ?', "%#{search_params[:name]}%") : g }
         .then { |g| search_params[:status].present? ? g.where(active: search_params[:status]) : g }
         .then { |g| g.order(safe_sort_order) }
  end

  def safe_sort_order
    allowed_columns = %w[name updated_at]
    allowed_directions = %w[asc desc]

    column = search_params[:sort]
    direction = params[:order]

    column = allowed_columns.include?(column) ? column : 'name'
    direction = allowed_directions.include?(direction) ? direction : 'asc'

    { column => direction.to_sym }
  end
end
