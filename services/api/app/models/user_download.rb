class UserDownload < ApplicationRecord
  belongs_to :user
  belongs_to :collection, optional: true

  def expired?
    expires_at.present? && Time.current > expires_at
  end

  def available?
    !expired? && File.exist?(file_path)
  end
end
