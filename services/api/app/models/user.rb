class User < ApplicationRecord
  include Confirmable

  has_secure_password

  after_create_commit :send_confirmation_email

  has_many :sessions, dependent: :destroy
  has_many :store_memberships
  has_many :stores, through: :store_memberships
  has_many :owned_stores, class_name: 'Store', foreign_key: :owner_id
  has_many :user_downloads, dependent: :destroy

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password_digest, :first_name, :last_name,  presence: true

  validate :password_complexity

  before_create :capitalize_names

  generates_token_for :invitation_confirmation, expires_in: 1.hour

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def generate_invitation_token
    generate_token_for(:invitation_confirmation)
  end

  def send_invitation_email(email, store)
    SendEmailInvitationJob.perform_later(self, email, store)
  end

  private

  def capitalize_names
    %i[first_name last_name].each { |attr| self[attr] = self[attr]&.titleize }
  end

  def password_complexity
    return if password.blank?

    unless password.match?(/(?=.*[a-z])/)
      errors.add :password, 'must include at least one lowercase letter'
    end

    unless password.match?(/(?=.*[A-Z])/)
      errors.add :password, 'must include at least one uppercase letter'
    end

    unless password.match?(/(?=.*\d)/)
      errors.add :password, 'must include at least one number'
    end

    unless password.match?(/(?=.*[^A-Za-z0-9])/)
      errors.add :password, 'must include at least one special character'
    end

    unless password.length >= 11
      errors.add :password, 'must be at least 11 characters long'
    end
  end
end
