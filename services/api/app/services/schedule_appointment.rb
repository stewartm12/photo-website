class ScheduleAppointment
  def initialize(store:, user: nil)
    @store = store
    @user = user
  end

  def call(customer:, package_id:, add_on_ids: [], preferred_date_time: nil, additional_notes: nil, status: 'pending', deposit: 0, address: nil, note: nil)
    @appointment = @store.appointments.new(
      customer: customer,
      preferred_date_time: preferred_date_time,
      additional_notes: additional_notes,
      status: status,
      deposit: deposit
    )

    assign_package(package_id)
    assign_add_ons(add_on_ids)
    assign_location(address, note) if address.present?

    @appointment.save!

    @appointment
  end

  private

  def assign_package(package_id)
    package = @store.packages.find_by(id: package_id)

    @appointment.build_appointment_package(
      name: package.name,
      price: package.price,
      edited_images: package.edited_images,
      outfit_change: package.outfit_change,
      duration: package.duration,
      features: package.features,
      gallery_name: package.gallery.name
    )
  end

  def assign_add_ons(add_on_ids)
    return unless add_on_ids.present?

    @store.add_ons.where(id: add_on_ids).each do |add_on|
      @appointment.appointment_add_ons.build(
        quantity: 1,
        name: add_on.name,
        price: add_on.price,
        limited: add_on.limited
      )
    end
  end

  def assign_location(address, note)
    @appointment.locations.build(address: address, note: note)
  end
end
