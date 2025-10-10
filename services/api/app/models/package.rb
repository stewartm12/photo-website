class Package < ApplicationRecord
  belongs_to :gallery, counter_cache: true

  validates :price, :gallery, presence: true
  validates :name, presence: true, uniqueness: { scope: :gallery_id }
  validates :outfit_change, inclusion: { in: [true, false] }

  after_commit :revalidate_frontend_cache, on: %i[create update destroy]

  def formatted_duration
    hours = duration / 60
    minutes = duration % 60

    return "#{hours} hours #{minutes} minutes" if hours > 0 && minutes > 0

    return "#{hours} hours" if hours > 0

    "#{minutes} minutes"
  end

  private

  def revalidate_frontend_cache
    FrontendCacheRevalidationJob.perform_later(tags: ['packages'])
  end
end
