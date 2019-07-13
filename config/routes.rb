Rails.application.routes.draw do
  root 'sessions#new'
  
  resources :users, except: [:index, :show]
  resources :tasks

  resources :sessions, only: [:new, :create, :destroy]
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
end
