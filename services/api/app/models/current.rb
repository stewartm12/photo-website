class Current < ActiveSupport::CurrentAttributes
  attribute :session, :store
  delegate :user, to: :session, allow_nil: true
end
