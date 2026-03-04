Rails.application.routes.draw do
  # health check и PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Профили
  resources :profiles, only: [ :index, :show, :new, :create, :edit, :update ] do
    member do
      get :content
      get :bookmarks
    end
  end

  # API
  namespace :api do
    resources :profiles, only: [ :update ]
    resources :posts, only: [ :create, :update, :destroy ]
    resources :comments, only: [ :create, :update, :destroy ]
  end

  # Теги
  resources :tags, only: [ :index, :show ]

  # Статьи
  resources :articles do
    collection do
      get :tagged
    end
  end

  # Посты
  resources :posts do
    collection do
      get :feed
      get :popular
      get :search
    end

    resources :comments, only: [ :create, :edit, :update, :destroy ], shallow: true
    resources :likes, only: [ :create ], shallow: true
    resources :favorites, only: [ :create ], shallow: true

    member do
      post :toggle_like
      post :toggle_bookmark
    end
  end

  resources :likes, only: [ :destroy ]
  resources :favorites, only: [ :destroy ]

  resources :subscriptions, only: [ :create, :destroy ]

  resources :messages, only: [ :index, :show, :create, :destroy ] do
    collection do
      get :sent
      get :inbox
    end
  end

  # Админская часть
  namespace :admin do
    root to: "dashboard#index"
    resources :users
    resources :posts, except: [ :index, :show ] do
      resources :comments, only: [ :index, :destroy ]
    end
    resources :subscriptions, only: [ :index, :destroy ]
    resources :tags, only: [ :index, :create, :edit, :update, :destroy ]
    resources :application_forms, only: [ :index, :show, :destroy ]
  end

  # вход
  get    "/signin",  to: "sessions#new"
  post   "/signin",  to: "sessions#create"
  delete "/signout", to: "sessions#destroy"

  # регистрация
  get  "/registration", to: "users#new",    as: :registration
  post "/registration", to: "users#create"

  resources :users, only: [ :new, :create, :edit, :update, :show ]

  # статические страницы
  get "about", to: "home#about"
  get "willbesoon", to: "home#willbesoon"
  get "feed", to: "home#feed"
  get "user", to: "home#user"


  # обработчики ошибок
  match "/403", to: "errors#forbidden", via: :all
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_error", via: :all
  match "*path", to: "errors#not_found", via: :all

  # главная страница
  root "home#about"
end
