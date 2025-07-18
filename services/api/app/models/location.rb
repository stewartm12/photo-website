class Location < ApplicationRecord
  include Eventeable

  encrypts :address
  encrypts :note

  belongs_to :appointment

  after_create :log_location_created_event
  after_update :log_location_updated_event

  validates :address, presence: true

  TRACKED_CHANGES = %i[
    address
    note
  ].freeze

  private

  def log_location_created_event
    log_event(
      :location_added,
      'New location has been added.'
    )
  end

  def log_location_updated_event
    updated_field(:location_updated)
  end

  def generate_change_message(attr, from, to)
    case attr
    when :address
      "Updated address from '#{from}' -> '#{to}'"
    when :note
      "Changed appointment time from '#{from}' -> '#{to}'"
    end
  end
end
