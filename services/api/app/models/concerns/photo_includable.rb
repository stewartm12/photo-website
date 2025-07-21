module PhotoIncludable
  extend ActiveSupport::Concern

  included do
    scope :with_eager_loaded_photos, -> {
      includes(
        photos: {
          image_attachment: [
            blob: {
              variant_records: :blob
            }
          ]
        }
      )
    }
  end
end
