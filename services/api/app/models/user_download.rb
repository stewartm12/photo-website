class UserDownload < ApplicationRecord
  belongs_to :user
  belongs_to :collection, optional: true

  scope :expired, -> { where('expires_at IS NOT NULL AND expires_at < ?', Time.current) }
  scope :not_expired, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }

  def expired?
    expires_at.present? && Time.current > expires_at
  end

  def available?
    !expired? && File.exist?(file_path)
  end
end
