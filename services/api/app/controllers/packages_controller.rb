class PackagesController < ApplicationController
  before_action :set_package, only: %i[edit update destroy]

  def new
    @package = gallery.packages.new
  end

  def create
    @package = gallery.packages.new(package_params)

    if @package.save
      flash.now[:success] = 'Package created successfully'
    else
      flash.now[:alert] = @package.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    if @package.update(package_params)
      flash.now[:success] = 'Package updated successfully'
    else
      flash.now[:alert] = @package.errors.full_messages.to_sentence
    end
  end

  def destroy
    @package.destroy
    flash.now[:success] = 'Package deleted successfully'
  end

  private

  def package_params
    params.expect(package:
      [
        :name,
        :price,
        :edited_images,
        :outfit_change,
        :duration,
        :popular,
        features: []
      ]
    )
  end

  def set_package
    @package = gallery.packages.find_by(id: params[:id])
  end

  def gallery
    @gallery ||= Current.store.galleries.find_by(id: params[:gallery_id])
  end
end
