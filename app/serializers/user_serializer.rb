class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :fullName, :phoneNumber, :address, :role

  def fullName
    object.full_name
  end

  def phoneNumber
    object.phone_number
  end

  def address
    ActiveModelSerializers::SerializableResource.new(object.addresses, each_serializer: AddressSerializer)
  end
end
