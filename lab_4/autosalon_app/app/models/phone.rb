class Phone < ApplicationRecord
  belongs_to :salon

  VALID_PHONE_REGEX = /\A\+?\d{7,15}\z/
  validates :number,
            presence: true,
            format: { with: VALID_PHONE_REGEX,
                      message: "повинен бути у форматі, наприклад +380123456789" }
end
