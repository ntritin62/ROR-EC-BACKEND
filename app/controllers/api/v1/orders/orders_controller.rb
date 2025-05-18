class Api::V1::Orders::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
  before_action :set_address, only: %i(create_order_stripe create_order_cod)
  before_action :check_cart_empty, only: %i(create_order_stripe create_order_cod)
  before_action :authenticate_admin!, only: %i(update_order all_orders show_order)
  before_action :set_order, only: %i(update_order show_order)

  def stripe
    render_json(
      status: :ok,
      message: t("stripe.payment_intent_success"),
      data: {
        publishableKey: ENV["STRIPE_PUBLISHABLE_KEY"]
      },
      http_status: :ok
    )
  end

  def create_payment_intent
    Stripe.api_key = ENV['STRIPE_SECRET_KEY'] 
    
    begin
      total_price = @cart.cart_items.sum { |item| item.product.price }
      payment_intent = Stripe::PaymentIntent.create({
        amount: total_price.to_i, 
        currency: "vnd",
        automatic_payment_methods: {enabled: true},
      })

      render_json(
        status: :ok,
        message: t("stripe.payment_intent_success"),
        data: {
          clientSecret: payment_intent.client_secret
        },
        http_status: :ok
      )
    rescue Stripe::StripeError => e
      render_json(
        status: :error,
        message: t("stripe.payment_intent_failed"),
        data: { error: e.message },
        http_status: :unprocessable_entity
      )
    end
  end

  def create_order_stripe
    begin
      payment_intent = Stripe::PaymentIntent.retrieve(params[:payment_intent_id])

      if payment_intent.status == 'succeeded'
        order = current_user.orders.create!(
          total: @cart.total_price,
          address: @address,
          status: :paid,
          payment_method: :stripe,
          payment_intent_id: payment_intent.id,
          client_secret: params[:client_secret]
        )

        @cart.cart_items.each do |cart_item|
          order.order_items.create!(
            product: cart_item.product,
            price: cart_item.product.price
          )
        end

        @cart.clear_cart_items
        Rails.cache.delete("user_#{current_user.id}_orders")

        render_json(
          status: :created,
          message: t(".orders.created_successfully"),
          data: {},
          http_status: :created
        )
      else
        render_json(
          status: :error,
          message: t(".orders.payment_failed"),
          data: {error: t(".orders.payment_failed")},
          http_status: :unprocessable_entity
        )
      end
    rescue Stripe::StripeError => e
      render_json(
        status: :error,
        message: e.message,
        data: { error: e.message },
        http_status: :unprocessable_entity
      )
    end
  end

  def create_order_cod
    Order.transaction do
      order = current_user.orders.create!(
        total: @cart.total_price,
        address: @address,
        status: :pending, 
        payment_method: :cod
      )

      current_user.cart.cart_items.each do |cart_item|
        order.order_items.create!(
          product: cart_item.product,
          price: cart_item.product.price
        )
      end
  
      @cart.clear_cart_items
      Rails.cache.delete("user_#{current_user.id}_orders")
  
      render_json(
        status: :created,
        message: t(".created_successfully"),
        data: { order: order },
        http_status: :created
      )
    rescue => e
      render_json(
        status: :error,
        message: e.message,
        data: {error: e.message},
        http_status: :unprocessable_entity
      )
    end
  end
  
  def update_order
    if Order.statuses.keys.exclude?(params[:order_status])
      return render_json(
        status: :error,
        message: t(".invalid_status"),
        data: { error: t(".invalid_status") },
        http_status: :unprocessable_entity
      )
    end

    if @order.update(status: params[:order_status])
      Rails.cache.delete("order_#{@order.id}")
      Rails.cache.delete("user_#{@order.user_id}_orders")
      render_json(
        status: :ok,
        message: t(".updated_successfully"),
        data: { order: @order },
        http_status: :ok
      )
    else
      render_json(
        status: :error,
        message: t(".update_failed"),
        data: { error: t(".update_failed") },
        http_status: :unprocessable_entity
      )
    end
  end

  def all_orders
    orders_json = Rails.cache.fetch("all_orders", expires_in: 5.minutes) do
      orders = Order.includes(:order_items).all.recent
      ActiveModelSerializers::SerializableResource.new(orders, each_serializer: OrderSerializer).as_json
    end
  
    render_json(
      status: :ok,
      message: t(".fetched_successfully"),
      data: orders_json,
      http_status: :ok
    )
  end

  def user_orders
    cache_key = "user_orders_#{current_user.id}"
    
    orders_json = Rails.cache.fetch(cache_key, expires_in: 5.minutes) do
      orders = current_user.orders.includes(:order_items).recent
      ActiveModelSerializers::SerializableResource.new(orders, each_serializer: OrderSerializer).as_json
    end
  
    render_json(
      status: :ok,
      message: t(".fetched_successfully"),
      data: orders_json,
      http_status: :ok
    )
  end

  def show_order
    if @order
      render_json(
        status: :ok,
        message: t(".fetched_successfully"),
        data: OrderSerializer.new(@order),
        http_status: :ok
      )
    else
      render_json(
        status: :not_found,
        message: t(".not_found"),
        data: {},
        http_status: :not_found
      )
    end
  end

  private
  def set_order
    @order = Rails.cache.fetch("order_#{params[:order_id]}", expires_in: 5.minutes) do
      Order.find_by(id: params[:order_id])
    end
    return if @order.present?

    render_json(
      status: :not_found,
      message: t(".order_not_found"),
      errors: [t(".order_not_found")],
      http_status: :not_found
    )
  end

  def set_cart
    @cart = current_user.cart
  end

  def set_address
    @address = current_user.addresses.find_by(id: params[:address_id])
    return if @address.present?

    render_json(
      status: :not_found,
      message: t(".address_not_found"),
      errors: [t(".address_not_found")],
      http_status: :not_found
    )
  end

  def check_cart_empty
    return unless @cart.cart_items.empty?

    render_json(
      status: :error,
      message: t(".cart_empty"),
      data: { error: t(".cart_empty") },
      http_status: :unprocessable_entity
    )
  end
end
