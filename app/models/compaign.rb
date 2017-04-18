class Compaign < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  belongs_to :user, optional: true
end
