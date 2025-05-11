class Salon < ApplicationRecord
    has_many :cars,   dependent: :destroy
    has_many :phones, dependent: :destroy
  
    validates :name,    presence: true, uniqueness: true
    validates :address, presence: true, length: { minimum: 5 }
  end
  