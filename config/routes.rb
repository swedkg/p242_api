# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  # mount ActionCable.server => '/cable'

  # devise_for :users
  devise_for :users, only: []

  resources :users
  resources :requests
  resources :fullfilments
  resources :messages
  resources :sessions
  # resources :sessions, only: [:create, :destroy]
  get '/platform/:status', to: 'requests#status'
  delete '/user/:logout', to: 'sessions#logout'
  
end
