class Api::V1::Orders::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_cart
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

  private
  def set_cart
    @cart = current_user.cart
  end
end
