class AddOnsController < ApplicationController
  before_action :set_add_on, only: %i[edit update destroy]

  def new
    @add_on = gallery.add_ons.new
  end

  def create
    @add_on = gallery.add_ons.new(add_on_params)

    if @add_on.save
      flash.now[:success] = 'Add-on created successfully'
    else
      flash.now[:alert] = @add_on.errors.full_messages.to_sentence
    end
  end

  def edit; end

  def update
    if @add_on.update(add_on_params)
      flash.now[:success] = 'Add-on updated successfully'
    else
      flash.now[:alert] = @add_on.errors.full_messages.to_sentence
    end
  end

  def destroy
    @add_on.destroy
    flash.now[:success] = 'Add-on deleted successfully'
  end

  private

  def add_on_params
    params.expect(add_on: %i[name price limited])
  end

  def set_add_on
    @add_on = gallery.add_ons.find_by(id: params[:id])
  end

  def gallery
    @gallery ||= Current.store.galleries.find_by(id: params[:gallery_id])
  end
end
