Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "login", to: "auths#login"
    end
  end
end
