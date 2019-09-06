Rails.application.routes.draw do
  resources :requests
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :sessions, only: [:create, :destroy]
end
