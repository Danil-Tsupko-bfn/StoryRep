class Car < ApplicationRecord
  belongs_to :salon

  validates :name, presence: true
end
