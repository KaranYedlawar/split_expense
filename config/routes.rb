Rails.application.routes.draw do
  devise_for :users
  
  root "static#dashboard"
  get "/dashboard", to: "static#dashboard", as: :dashboard
  post "/settle_up", to: "settlements#create", as: :settle_up

  resources :expenses, only: [:create]
  resources :users, only: [:index, :show]
end
