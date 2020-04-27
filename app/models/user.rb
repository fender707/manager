class User < ApplicationRecord
  has_many :logins, dependent: :destroy
  has_many :directories, inverse_of: :user, dependent: :destroy
end
