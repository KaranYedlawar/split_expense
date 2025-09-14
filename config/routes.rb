Rails.application.routes.draw do
  devise_for :users
  
  root "static#dashboard"
  resources :expenses, only: [:create]
  resources :users, only: [:index, :show]
end
