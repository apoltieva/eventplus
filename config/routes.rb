# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events, except: [:edit]
  root to: 'events#index'
  resources :users, only: %i[new create]
  get 'login', to: 'sessions#login'
  post 'login', to: 'sessions#create'
end
