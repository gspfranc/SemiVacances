Rails.application.routes.draw do

  get 'vacance_day/approbation'

  root :to => "sessions#login"
  get "signup", :to => "users#new"
  get "login", :to => "sessions#login"
  get "logout", :to => "sessions#logout"
  get "home", :to => "sessions#home"
  match  "login_attempt", :to => "sessions#login_attempt", via: [:get, :post]

  resources :users do
    resources :vacances do
    end
  end


  match "users/:user_id/vacances/:id", :to => "vacance_day#approbation_vacancedays", via: [:post]
  match "report/user_report", :to => "report#user_report", via:  [:get, :post], as: "report_user_report"

  match "users/:id/roles/", :to => "roles#edit", via: [:get, :post], as: "user_role_edit"

end
