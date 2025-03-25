class OrderSerializer < ActiveModel::Serializer
  attributes :id, :address, :payment_method, :status, :total, :created_at, :user

  has_many :order_items
  belongs_to :address, serializer: AddressSerializer
  belongs_to :user, serializer: UserSerializer
end
