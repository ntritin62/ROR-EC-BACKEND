class Order < ApplicationRecord
  belongs_to :user
  belongs_to :address
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  
  enum status: {
    pending: 0,
    paid: 1,
    confirmed: 2,
    preparing: 3,
    delivering: 4,
    delivered: 5,
    cancelled: 6
  }, _suffix: true

  validates :total, presence: true,
    numericality: {greater_than_or_equal_to: 0}
  validates :status, presence: true
end
