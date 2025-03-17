Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :api do
      namespace :v1 do
        post "login", to: "auths#login"
        post "signup", to: "auths#sign_up"
        patch "users/updateUser", to: "auths#update"
        get "users/showMe", to: "auths#show"

        namespace :carts do
          post "add_product", to: "carts#add_product"
          get "showMyCart", to: "carts#show"
          delete ":product_id", to: "carts#remove_product"
        end

        namespace :orders do
          get "stripe", to: "orders#stripe"
          get "createPaymentIntent", to: "orders#create_payment_intent"
          post "createOrderStripe", to: "orders#create_order_stripe"
          post "createOrderCOD", to: "orders#create_order_cod"
          patch "updateOrderStatus", to: "orders#update_order"
          get "showAllMyOrders", to: "orders#user_orders"
          get "", to: "orders#all_orders"
          get ":order_id", to: "orders#show_order"
        end

        namespace :laptops do
          get "", to: "laptops#index"
          get ":id", to: "laptops#show"
          post "", to: "laptops#create"
          patch ":id", to: "laptops#update"
          delete ":id", to: "laptops#destroy"
        end

        namespace :addresses do
          get "showMyAddresses", to: "addresses#index"
          get ":id", to: "addresses#show"
          post "", to: "addresses#create"
          patch ":id", to: "addresses#update"
          delete ":id", to: "addresses#destroy"
        end
      end
    end
  end
end
