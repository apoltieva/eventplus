# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events, except: [:edit]
  resources :venues, except: [:show]
  root to: 'events#index'
  devise_for :users, controllers: {
    sign_up: 'users/sign_up'
  }
end
