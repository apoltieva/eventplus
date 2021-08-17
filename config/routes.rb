# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events
  resources :venues, except: [:show]
  root to: 'events#index'
  devise_for :users, controllers: {
    sign_up: 'users/sign_up'
  }
  resources :orders, only: %i[create show]
end
