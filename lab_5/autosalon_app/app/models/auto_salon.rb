class AutoSalon < ApplicationRecord
    has_many :cars
    has_many :phones
  end
