class Location < ApplicationRecord
  encrypts :address
  encrypts :note

  belongs_to :appointment

  validates :address, presence: true
end
