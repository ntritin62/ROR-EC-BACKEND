class Api::V1::Laptops::LaptopsController < ApplicationController
  before_action :authenticate_user!, :authenticate_admin!, only: %i[create update destroy]
  before_action :set_product, only: %i[show update destroy]

  def index
    laptops = Product.all.recent
    render_json(
      status: :ok,
      message: t(".success"),
      data: ActiveModelSerializers::SerializableResource.new(laptops, each_serializer: ProductSerializer),
      http_status: :ok
    )
  end

  def show
    render_json(
      status: :ok,
      message: t(".success"),
      data:  ActiveModelSerializers::SerializableResource.new(@laptop),
      http_status: :ok
    )
  end

  def create
    laptop = Product.new(laptop_params)
    if laptop.save
      render_json(
        status: :created,
        message: t(".success"),
        data: laptop,
        http_status: :created
      )
    else
      render_json(
        status: :unprocessable_entity,
        message: t(".failure"),
        errors: laptop.errors.full_messages,
        http_status: :unprocessable_entity
      )
    end
  end

  def update
    if @laptop.update(laptop_params)
      render_json(
        status: :ok,
        message: t(".success"),
        data: @laptop,
        http_status: :ok
      )
    else
      render_json(
        status: :unprocessable_entity,
        message: t(".failure"),
        errors: @laptop.errors.full_messages,
        http_status: :unprocessable_entity
      )
    end
  end

  def destroy
    if @laptop.destroy
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

  def set_product
    @laptop = Product.find_by(id: params[:id])
    return if @laptop.present?

    render_json(status: :not_found, message: t(".not_found"), http_status: :not_found)
  end

  def laptop_params
    params.require(:laptop).permit Product::REQUIRED_ATTRIBUTES
  end
end
