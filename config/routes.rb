# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do

  # mount ActionCable.server => '/cable'

  # devise_for :users
  devise_for :users, only: []

  resources :users, only: [:show, :create]
  #TODO:                 why :show has to be here?

  # resources :requests, except: [:destroy, :update, :show]
  # TODO: why this ^^ makes the test fail?
  
  resources :requests, except: [:destroy, :update]
  resources :fullfilments, only: [:index, :create]
  resources :messages, only: [:index, :create]
  # resources :sessions
  resources :sessions, only: [:create, :logout]
  get '/platform/:status', to: 'requests#status'
  delete '/user/:logout', to: 'sessions#logout'
  
end
