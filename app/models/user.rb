class User < ApplicationRecord
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :compaigns, dependent: :nullify 
end
