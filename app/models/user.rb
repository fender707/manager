class User < ApplicationRecord
  has_many :directories, inverse_of: :user, dependent: :destroy

  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
end
