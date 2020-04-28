class User < ApplicationRecord
  has_many :directories, inverse_of: :user, dependent: :destroy
  has_many :notes, inverse_of: :user, dependent: :destroy

  has_one :access_token, dependent: :destroy

  validates :login, presence: true, uniqueness: true
  validates :provider, presence: true
end
