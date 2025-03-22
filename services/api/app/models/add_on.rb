class AddOn < ApplicationRecord
  belongs_to :gallery
  has_many :appointment_add_ons
  has_many :appointments, through: :appointment_add_ons

  validates :name, :price, presence: true
end
