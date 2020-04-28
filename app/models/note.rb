class Note < ApplicationRecord
  belongs_to :directory, inverse_of: :notes
  belongs_to :user, inverse_of: :notes

  validates :title, presence: true
end
