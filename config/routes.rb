Rails.application.routes.draw do
  root 'sessions#new'
  
  namespace :admin do
    root 'backend#index'
    resources :users
  end

  resources :user, except: [:index, :show, :destroy]
  get 'signup', to: 'user#new', as: 'signup'
  
  resources :tasks

  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
end
