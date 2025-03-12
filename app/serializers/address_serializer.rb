class AddressSerializer < ActiveModel::Serializer
  attributes :id, :recipientName, :deliveryAddress, :contactNumber

  def recipientName
    object.receiver_name
  end

  def deliveryAddress
    object.place
  end

  def contactNumber
    object.phone
  end
end
