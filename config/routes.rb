# frozen_string_literal: true

Rails.application.routes.draw do
  resources :events
  resources :venues, except: [:show]
  root to: 'events#index'
  devise_for :users, controllers: {
    sign_up: 'users/sign_up'
  }
  resource :cart, only: [:show] do
    put 'add/:event_id', to: 'carts#add', as: :add_to
    put 'remove/:event_id', to: 'carts#remove', as: :remove_from
    put 'remove_one/:event_id', to: 'carts#removeone', as: :remove_one
  end
end
