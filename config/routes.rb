Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :api do
      namespace :v1 do
        post "login", to: "auths#login"
        post "signup", to: "auths#sign_up"
        put "update_user", to: "auths#update"
        
        namespace :carts do
          post "add_product", to: "carts#add_product"
          get "", to: "carts#show"
          delete ":product_id", to: "carts#remove_product"
        end

        namespace :orders do
          get "stripe", to: "orders#stripe"
          get "createPaymentIntent", to: "orders#create_payment_intent"
          post "createOrderStripe", to: "orders#create_order_stripe"
          post "createOrderCOD", to: "orders#create_order_cod"
        end
      end
    end
  end
end
