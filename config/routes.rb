Rails.application.routes.draw do
  devise_for :users
  resources :requests
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :sessions, only: [:create, :destroy]
end
