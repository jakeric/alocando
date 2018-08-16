Rails.application.routes.draw do
  root to: 'pages#home'
  devise_for :users

  resources :flight_bundles, only: [:index, :show, :create, :destroy]

  get 'about', to: 'pages#about'
  get 'terms', to: 'pages#terms'
  get 'FAQ', to: 'pages#faq', as: 'faq'
end
