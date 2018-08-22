Rails.application.routes.draw do
  root to: 'pages#home', as: 'home'
  devise_for :users

  resources :flight_bundles, only: [:index, :show, ]
  resources :cities, only: [:index]


  post 'share', to: 'share#share'
  get 'about', to: 'pages#about'
  get 'terms', to: 'pages#terms'
  get 'FAQ', to: 'pages#faq', as: 'faq'
  get 'flight_details', to: 'flight_bundles#index'
end
