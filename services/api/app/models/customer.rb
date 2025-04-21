class Customer < ApplicationRecord
  encrypts :phone_number

  has_many :appointments

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_create :capitalize_names

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def capitalize_names
    self.first_name = first_name.split.map(&:capitalize).join(' ')
    self.last_name = last_name.split.map(&:capitalize).join(' ')
  end
end
