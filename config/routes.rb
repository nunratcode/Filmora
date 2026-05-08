Rails.application.routes.draw do
  mount ActiveStorage::Engine => "/rails/active_storage"

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
  resources :posts, only: [ :new, :create, :show, :destroy ] do
    collection do
      get :feed
      get :popular
      get :search
    end
  end

  # Пароль
  resource :password, only: [ :edit, :update ]

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

  # выход
  delete "/signout", to: "sessions#destroy", as: :signout

  # регистрация
  get  "/registration", to: "users#new",    as: :registration
  post "/registration", to: "users#create"

  resources :users, only: [ :new, :create, :edit, :update, :show ]

  # подписка
  get  "/subscription", to: "home#subscription"
  post "/subscription", to: "home#create_subscription"
  resources :subscriptions, only: [ :create ]

  # сброс пароля
  get  "/password_reset",        to: "password_resets#new",    as: :password_reset
  post "/password_reset",        to: "password_resets#create"
  get  "/password_reset/:token", to: "password_resets#edit",   as: :edit_password_reset
  patch "/password_reset/:token", to: "password_resets#update"

  resources :password_resets, only: [ :new, :create, :edit, :update ]

  # страница пользователя
  resources :users, only: [ :new, :create, :edit, :update, :show ]
  get "/user", to: "users#show"

  # статические страницы
  get "about", to: "home#about"
  get "willbesoon", to: "home#willbesoon"
  get "feed", to: "home#feed"
  get "subscription", to: "home#subscription"


  # обработчики ошибок
  match "/403", to: "errors#forbidden", via: :all
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_error", via: :all
  match "*path", to: "errors#not_found", via: :all,
    constraints: lambda { |req| !req.path.start_with?("/rails/active_storage") }

  # главная страница
  root "home#about"
end
