# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events
  resources :venues, except: [:show]
  root to: 'events#index'
  devise_for :users, controllers: {
    sign_up: 'users/sign_up'
  }
  resources :orders, only: %i[create show new]
  resources :webhooks, only: %i[create]
  get '/success', to: 'orders#success', as: :success_checkout
  get '/cancel', to: 'orders#cancel', as: :cancel_checkout
  get '/help', to: 'events#help', as: :help

  mount ActionCable.server, at: '/cable'
end
