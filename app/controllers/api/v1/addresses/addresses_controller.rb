class Api::V1::Addresses::AddressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_address, only: %i[show update destroy]

  def index
    addresses = current_user.addresses
    render_json(
      status: :ok,
      message: t(".success"),
      data: ActiveModelSerializers::SerializableResource.new(addresses, each_serializer: AddressSerializer),
      http_status: :ok
    )
  end

  def show
    render_json(
      status: :ok,
      message: t(".success"),
      data: AddressSerializer.new(@address),
      http_status: :ok
    )
  end

  def create
    address = current_user.addresses.new(address_params)
    if address.save
      render_json(
        status: :created,
        message: t(".success"),
        data: AddressSerializer.new(address),
        http_status: :created
      )
    else
      render_json(
        status: :unprocessable_entity,
        message: t(".failure"),
        errors: address.errors.full_messages,
        http_status: :unprocessable_entity
      )
    end
  end

  def update
    if @address.update(address_params)
      render_json(
        status: :ok,
        message: t(".success"),
        data: AddressSerializer.new(@address),
        http_status: :ok
      )
    else
      render_json(
        status: :unprocessable_entity,
        message: t(".failure"),
        errors: @address.errors.full_messages,
        http_status: :unprocessable_entity
      )
    end
  end

  def destroy
    if @address.destroy
      render_json(
        status: :ok,
        message: t(".success"),
        http_status: :ok
      )
    else
      render_json(
        status: :unprocessable_entity,
        message: t(".failure"),
        http_status: :unprocessable_entity
      )
    end
  end

  private

  def set_address
    @address = current_user.addresses.find_by(id: params[:id])
    return if @address.present?

    render_json(
      status: :not_found,
      message: t(".not_found"),
      http_status: :not_found
    )
  end

  def address_params
    {
      receiver_name: params[:recipient_name],
      phone: params[:contact_number],
      place: params[:delivery_address]
    }
  end
end
