Rails.application.routes.draw do
  devise_for :users
  resources :requests
  resources :fullfilments
  resources :messages
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :sessions, only: [:create, :destroy]
  get '/platform/:status', to: 'requests#status'
end
