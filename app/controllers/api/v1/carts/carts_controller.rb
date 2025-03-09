class Api::V1::Carts::CartsController < ApplicationController
  include Response
  before_action :authenticate_user!
  before_action :set_product, only: :add_product

  def add_product
    @cart = current_user.cart

    @cart_item = @cart.cart_items.find_by(product: @product)

    if @cart_item
      render_json(
        status: :unprocessable_entity,
        message: t(".product_exists"),
        data: CartSerializer.new(@cart),
        http_status: :unprocessable_entity,
      )
    else
      @cart_item = @cart.cart_items.create(product: @product)

      if @cart_item.persisted?
        render_json(
          status: :created,
          message: t(".product_added"),
          data: CartSerializer.new(@cart),
          http_status: :created
        )
      else
        render_json(
          status: :unprocessable_entity,
          message: t(".product_add_error"),
          errors: [t(".product_add_error")],
          http_status: :unprocessable_entity
        )
      end
    end
  end

  private
  def set_product
    @product = Product.find_by(id: params[:product_id].to_s)
    return if @product.present?

    render_json(
      status: :not_found,
      message: t(".product_not_found"),
      errors: [t(".product_not_found")],
      http_status: :not_found
    )
  end
end
