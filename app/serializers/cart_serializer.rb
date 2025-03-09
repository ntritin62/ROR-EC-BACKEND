class CartSerializer < ActiveModel::Serializer
  attributes :id, :total_price

  has_many :cart_items, serializer: CartItemSerializer

  
  def total_price
    object.cart_items.sum { |item| item.product.price }
  end
end
