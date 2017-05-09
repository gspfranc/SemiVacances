Rails.application.routes.draw do

  root :to => "sessions#login"
  get "signup", :to => "users#new"
  get "login", :to => "sessions#login"
  get "logout", :to => "sessions#logout"
  get "home", :to => "sessions#home"
  match  "login_attempt", :to => "sessions#login_attempt", via: [:get, :post]

  resources :users do
    resources :vacances, except: [:show]
  end

  match "users/:id/set_role/:role_id", :to => "users#set_role", via:  [:get], as: "user_set_role"


  match "approbation/:id/approuver", :to => "vacances#approuver", via:  [:get], as: "vacance_set_approbation"
  match "approbation/:id/refuser", :to => "vacances#refuser", via:  [:get], as: "vacance_set_refuser"

end
