Myflix::Application.routes.draw do
  
  root to: 'pages#front'

  get 'ui(/:action)', controller: 'ui'
  get 'home', to: 'videos#index'
  get 'register', to: 'users#new'
  get 'sign-in', to: 'sessions#new'
  get 'sign-out', to: 'sessions#destroy'

  resources :videos do
    collection do
      get 'search'
    end
  end

  resources :users, only: [:create]
  resources :sessions, only: [:create]
end
