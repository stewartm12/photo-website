class AppointmentPackagesController < ApplicationController
  def edit
    @appointment_package = appointment.appointment_package
    @galleries_and_packages = Current.store.galleries.includes(:packages).map do |gallery|
      {
        id: gallery.id,
        name: gallery.name,
        packages: gallery.packages.map(&:as_json)
      }
    end
  end

  def update
    @appointment_package = appointment.appointment_package
    gallery = Current.store.galleries.find_by(id: params[:appointment_package][:gallery_name])
    package = gallery.packages.find_by(id: params[:appointment][:package_id])

    if @appointment_package.name == package.name && @appointment_package.gallery_name == gallery.name
      flash.now[:notice] = 'Package already selected.'
    else
      @appointment_package.update(
        name: package.name,
        price: package.price,
        edited_images: package.edited_images,
        outfit_change: package.outfit_change,
        duration: package.duration,
        features: package.features,
        gallery_name: gallery.name
      )

      if @appointment_package.gallery_name == gallery.name
        appointment.appointment_add_ons.destroy_all
      end

      flash.now[:success] = 'Package updated successfully.'
    end
  end

  private

  def appointment
    @appointment ||= Current.store.appointments.find_by(id: params[:appointment_id])
  end
end
