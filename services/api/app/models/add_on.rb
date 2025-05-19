class AddOn < ApplicationRecord
  belongs_to :gallery, counter_cache: true
  has_many :appointment_add_ons
  has_many :appointments, through: :appointment_add_ons

  validates :name, :price, presence: true
end
