class AppointmentPackage < ApplicationRecord
  include Eventeable

  belongs_to :appointment

  validates :name, :price, :duration, :gallery_name, presence: true
  validates :outfit_change, inclusion: { in: [true, false] }

  after_update :log_appt_package_updated_event

  TRACKED_CHANGES = %i[
    name
  ].freeze

  private

  def log_appt_package_updated_event
    updated_field(:package_updated)
  end

  def generate_change_message(attr, from, to)
    case attr
    when :name
      "Updated package from '#{from}' -> '#{to}' under '#{gallery_name}'"
    end
  end
end
