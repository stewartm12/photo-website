class PricingsController < ApplicationController
  def index
    @galleries = filtered_galleries
  end

  def show; end

  def new; end

  def create; end

  def edit; end

  def update; end

  def destroy; end

  private

  def search_params
    params.permit(:name)
  end

  def filtered_galleries
    galleries = Current.store.galleries.preload(:collections, :add_ons, :packages)

    if search_params[:name].present?
      galleries = galleries.where('name ILIKE ?', "%#{search_params[:name]}%")
    end

    galleries
  end
end
