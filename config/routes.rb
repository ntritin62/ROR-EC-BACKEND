Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    namespace :api do
      namespace :v1 do
        post "login", to: "auths#login"
      end
    end
  end
end
