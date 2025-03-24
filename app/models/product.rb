class Product < ApplicationRecord
  REQUIRED_ATTRIBUTES = %i(
    name price status cpu ram hard_disk graphic_card screen 
    connection_port keyboard audio lan wireless_lan webcam os 
    battery weight image_url
  ).freeze

  has_many :cart_item, dependent: :destroy
  has_many :order_item, dependent: :destroy
  has_many :orders, through: :order_items

  validates :name, presence: true, length: { maximum: 255 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  validates :cpu, :ram, :hard_disk, :graphic_card, :screen, :connection_port, 
            :keyboard, :audio, :lan, :wireless_lan, :webcam, :os, :battery, 
            :weight, presence: true

  validates :image_url, presence: true, format: {with: Settings.value.valid_url}
end
