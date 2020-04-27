class Directory < ApplicationRecord
  belongs_to :user, inverse_of: :directories
  validates :title, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
