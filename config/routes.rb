Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :api do
      namespace :v1 do
        post "login", to: "auths#login"
        post "signup", to: "auths#sign_up"
        put "update_user", to: "auths#update"
      end
    end
  end
end
