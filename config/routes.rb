Rails.application.routes.draw do
  devise_for :users
  root to: 'articles#index'
  resources :journals
  resources :articles, only: [:index, :create, :show]
end
