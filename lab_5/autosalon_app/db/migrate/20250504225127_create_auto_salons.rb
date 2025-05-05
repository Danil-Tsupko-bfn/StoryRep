class Car < ApplicationRecord
  belongs_to :auto_salon
  validates :auto_salon, presence: true
end