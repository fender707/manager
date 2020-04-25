class Directory < ApplicationRecord
  validates :title, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
