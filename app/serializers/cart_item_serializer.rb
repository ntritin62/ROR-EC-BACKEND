class CartItemSerializer < ActiveModel::Serializer
  attributes :cart_items_id, :product

  belongs_to :product
  belongs_to :cart

  
  def cart_items_id
    object.id 
  end
end
