class UserDownload < ApplicationRecord
  belongs_to :user
  belongs_to :collection, optional: true

  has_one_attached :zip_file, dependent: :purge_later

  scope :expired, -> { where('expires_at IS NOT NULL AND expires_at < ?', Time.current) }
  scope :not_expired, -> { where('expires_at IS NULL OR expires_at > ?', Time.current) }

  def expired?
    expires_at.present? && Time.current > expires_at
  end

  def expire!
    return unless expires_at?

    self.expires_at = Time.current
    save!
  end

  def available?
    !expired? && zip_file.attached?
  end

  def seconds_until_expiration
    return 0 unless expires_at?
  
    [expires_at - Time.current, 0].max
  end

  def zip_file_url
    return nil unless zip_file.attached?

    Rails.application.routes.url_helpers.rails_blob_url(zip_file, disposition: 'attachment', expires_in: seconds_until_expiration)
  end
end
