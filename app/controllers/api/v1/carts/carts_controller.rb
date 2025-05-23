class Api::V1::Carts::CartsController < ApplicationController
  before_action :authenticate_user!, only: %i(show add_product remove_product)
  before_action :set_cart, only: %i(show add_product remove_product)
  before_action :set_product, only: %i(add_product remove_product)
 

  def show
    cart_data = Rails.cache.fetch("user_#{current_user.id}_cart", expires_in: 5.minutes) do
      CartSerializer.new(@cart).as_json
    end
    render_json(
      status: :ok,
      message: t(".cart_found"),
      data: cart_data,
      http_status: :ok,
    )
  end

  def add_product
    @cart_item = @cart.cart_items.find_by(product: @product)

    if @cart_item
      render_json(
        status: :ok,
        message: t(".product_exists"),
        data: CartSerializer.new(@cart),
        http_status: :ok,
      )
    else
      @cart_item = @cart.cart_items.create(product: @product)

      if @cart_item.persisted?
        Rails.cache.delete("user_#{current_user.id}_cart")
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

  def remove_product
    @cart_item = @cart.cart_items.find_by(product: @product)
    if @cart_item
      @cart_item.destroy
      Rails.cache.delete("user_#{current_user.id}_cart")
      render_json(
        status: :ok,
        message: t(".product_removed"),
        data: CartSerializer.new(@cart),
        http_status: :ok
      )
    else
      render_json(
        status: :not_found,
        message: t(".product_not_found_in_cart"),
        errors: [t(".product_not_found_in_cart")],
        http_status: :not_found
      )
    end
  end
  

  private
  def set_product
    @product = Rails.cache.fetch("laptop_#{params[:product_id]}", expires_in: 5.minutes) do
      Product.find_by(id: params[:product_id])
    end
    
    return if @product.present?

    render_json(
      status: :not_found,
      message: t(".product_not_found"),
      errors: [t(".product_not_found")],
      http_status: :not_found
    )
  end
  
  def set_cart
    @cart = current_user.cart
  end
end
