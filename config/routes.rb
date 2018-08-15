Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users

  resources :flight_bundles, only: [:index, :show, :create, :destroy]
  resources :flight_bundle_flights, only: [:create, :destroy]
  resources :flights, only: [:create, :update]
  resources :airports, only: [:create, :update]
  resources :airlines, only: [:create, :update]
  resources :cities, only: [:create, :update]
  resources :attachments, only: [:create, :update]

  get 'about', to: 'pages#about'
  get 'terms', to: 'pages#terms'
  get 'FAQ', to: 'pages#faq', as: 'faq'
end
