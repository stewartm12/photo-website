class Customer < ApplicationRecord
  encrypts :email, deterministic: true
  encrypts :phone_number

  has_many :appointments

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  before_create :capitalize_names

  private

  def capitalize_names
    self.first_name = first_name.split.map(&:capitalize).join(' ')
    self.last_name = last_name.split.map(&:capitalize).join(' ')
  end
end
