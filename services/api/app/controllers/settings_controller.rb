class SettingsController < ApplicationController
  def show
    @store = Store.includes(
      appointments: %i[appointment_add_ons appointment_package]
    ).find_by(slug: Current.store.slug)
  end
end
