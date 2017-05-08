Rails.application.routes.draw do



  root :to => "sessions#login"
  get "signup", :to => "users#new"
  get "login", :to => "sessions#login"
  get "logout", :to => "sessions#logout"
  get "home", :to => "sessions#home"
  match  "login_attempt", :to => "sessions#login_attempt", via: [:get, :post]

  resources :users do
    resources :vacances
  end


  match "users/:id/set_role/:role_id", :to => "users#set_role", via:  [:get], as: "user_set_role"


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


end
