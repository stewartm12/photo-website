class StoreMembership < ApplicationRecord
  belongs_to :user
  belongs_to :store

  validates :user_id, uniqueness: { scope: :store_id, message: 'is already a member of this store' }
end
