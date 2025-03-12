class OrderSerializer < ActiveModel::Serializer
  attributes :id, :address, :payment_method, :status, :total

  has_many :order_items
  belongs_to :address, serializer: AddressSerializer
end
