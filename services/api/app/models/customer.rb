class Customer < ApplicationRecord
  encrypts :phone_number

  belongs_to :store
  has_many :appointments

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :capitalize_names

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def capitalize_names
    self.first_name = first_name&.capitalize
    self.last_name = last_name&.capitalize
  end
end
