class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_items, dependent: :destroy

  def total_price
    cart_items.sum { |item| item.product.price }.to_i
  end

  def clear_cart_items
    cart_items.destroy_all
  end
end
