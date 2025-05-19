class Package < ApplicationRecord
  belongs_to :gallery, counter_cache: true
  has_many :appointments

  validates :name, :price, :gallery, presence: true

  def formatted_duration
    hours = duration / 60
    minutes = duration % 60

    return "#{hours} hours #{minutes} minutes" if hours > 0 && minutes > 0

    return "#{hours} hours" if hours > 0

    "#{minutes} minutes"
  end
end
