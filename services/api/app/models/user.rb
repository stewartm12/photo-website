class User < ApplicationRecord
  include Confirmable

  has_secure_password

  after_create_commit :send_confirmation_email

  has_many :sessions, dependent: :destroy
  has_many :store_memberships
  has_many :stores, through: :store_memberships

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, :first_name, :last_name,  presence: true

  before_create :capitalize_names

  def full_name
    "#{first_name} #{last_name}".strip
  end

  private

  def capitalize_names
    %i[first_name last_name].each { |attr| self[attr] = self[attr]&.titleize }
  end
end
