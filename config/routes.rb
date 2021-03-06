Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, except: [:new] do
    member do
      get :followings
      get :followers
      get :likes
    end
  end
  
  resources :shops, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  
  
  resources :messages, only: [:create]
  resources :rooms, only: [:create,:show]
  
  
  get 'searches/show'
  
end
