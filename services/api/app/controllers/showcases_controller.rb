class ShowcasesController < ApplicationController
  include Pagy::Backend

  before_action :set_showcase, only: %i[edit update destroy bulk_delete]

  def index
    load_showcases
  end

  def show
    @showcase = Current.store.showcases.includes(photos: { image_attachment: :blob }).find_by(id: params[:id])

    @showcase_photos = @showcase.photos.group_by(&:section_key)
    @showcase_sections = @showcase_photos.keys.sort
  end

  def new
    @showcase = Current.store.showcases.new
  end

  def create
    @showcase = Current.store.showcases.new(showcase_params)

    if @showcase.save
      flash.now[:success] = 'Showcase successfully created'
      load_showcases
    else
      flash.now[:alert] = @showcase.errors.full_messages.to_sentence
    end
  end

  def edit
    @case_type = params[:case_type] || 'info_update'
  end

  def update
    @case_type = params[:case_type] || 'info_update'

    case @case_type
    when 'info_update'
      if @showcase.update(showcase_params.except(:photo))
        flash.now[:success] = 'Showcase successfully updated'
        load_showcases
      else
        flash.now[:alert] = @showcase.errors.full_messages.to_sentence
      end
    when 'upload_photos'
      photo_param = showcase_params.dig(:photo)

      if photo_param[:image]
        @showcase.photos_changed = true
        @showcase.build_photo_from_image(photo_param[:image], store_slug: Current.store.slug, section_key: photo_param[:section_key], positioned: true)
        @section = showcase_params[:photo][:section_key]

        @existing_section = @showcase.photos.exists?(section_key: @section)
      end

      if @showcase.save
        flash.now[:success] = 'Showcase successfully updated'
        load_showcases
        @showcase_photos = @showcase.photos.group_by(&:section_key)
        @showcase_sections = @showcase_photos.keys.sort
        @photo = @showcase.photos.order(:id).last
      else
        flash.now[:alert] = @showcase.errors.full_messages.to_sentence
      end
    end
  end

  def destroy
    @showcase.destroy
    flash.now[:success] = 'Showcase deleted successfully'
    load_showcases
  end

  def bulk_delete
    @deleted_ids = params[:photo_ids]
    @showcase.photos.where(id: @deleted_ids).destroy_all
    @showcase.update(photos_count: @showcase.photos.count)
    @showcase_photos = @showcase.photos.group_by(&:section_key)
    @showcase_sections = @showcase_photos.keys

    flash.now[:success] = 'Photo(s) deleted successfully from showcase'
  end

  private

  def showcase_params
    params.expect(showcase: [:name, :description, photo: %i[section_key image]])
  end

  def search_params
    params.permit(:name)
  end

  def load_showcases
    @pagy, @showcases = pagy(filtered_showcases)
  end

  def set_showcase
    @showcase = Current.store.showcases.find_by(id: params[:id])
  end

  def filtered_showcases
    showcases = Current.store.showcases

    if search_params[:name].present?
      showcases = showcases.where('name ILIKE :q', q: "%#{search_params[:name]}%")
    end

    showcases
  end
end
