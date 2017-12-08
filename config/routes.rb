Myflix::Application.routes.draw do
  
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get 'register', to: 'users#new'
  get 'sign-in', to: 'sessions#new'
  get 'sign-out', to: 'sessions#destroy'
  get 'my_queue', to: 'queue_items#index'
  post 'my_queue', to: 'queue_items#update'
  get 'people', to: 'relationships#index'

  resources :videos do
    collection do
      get 'search'
    end
    resources :reviews, only: [:create]
  end

  resources :categories, only: [:show]
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  resources :relationships, only: [:destroy]
end
