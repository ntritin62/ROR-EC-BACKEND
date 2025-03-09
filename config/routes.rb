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
      end
    end
  end
end
