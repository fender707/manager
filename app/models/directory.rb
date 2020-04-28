class Directory < ApplicationRecord
  belongs_to :user, inverse_of: :directories
  belongs_to :parent_directory, class_name: 'Directory', foreign_key: :parent_directory_id, optional: true
  has_many :child_directories, class_name: 'Directory', foreign_key: :parent_directory_id, dependent: :destroy
  has_many :notes, inverse_of: :directory, dependent: :destroy
  validates :title, presence: true

  scope :recent, -> { order(created_at: :desc) }
end
