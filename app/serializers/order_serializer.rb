class OrderSerializer < ActiveModel::Serializer
  attributes :id, :address, :payment_method, :status, :total, :created_at

  has_many :order_items
  belongs_to :address, serializer: AddressSerializer
end
