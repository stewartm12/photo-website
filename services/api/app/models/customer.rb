class Customer < ApplicationRecord
  has_many :appointments

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
