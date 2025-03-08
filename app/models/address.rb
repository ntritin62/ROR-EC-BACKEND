class Address < ApplicationRecord
  belongs_to :user

  validates :receiver_name, presence: true,
            length: {maximum: Settings.value.max_name}
  validates :place, presence: true,
            length: {maximum: Settings.value.max_place_length}
  validates :phone, presence: true, format: {with: Settings.value.phone_format}
end
