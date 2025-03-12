class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :price, :product

  belongs_to :product
end
