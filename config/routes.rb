Rails.application.routes.draw do
  # Аутентификация через Devise
  devise_for :users

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

    # Комменты
    resources :comments, only: [ :create, :edit, :update, :destroy ], shallow: true

    # Лайки и закладки
    resources :likes, only: [ :create ], shallow: true
    resources :favorites, only: [ :create ], shallow: true

    # Тогглы для лайков и закладок
    member do
      post :toggle_like
      post :toggle_bookmark
    end
  end

  # Удаление лайков и закладок
  resources :likes, only: [ :destroy ]
  resources :favorites, only: [ :destroy ]

  # Подписки
  resources :subscriptions, only: [ :create, :destroy ]

  # Сообщения
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

  # Статические страницы
  get "about", to: "home#about"
  get "willbesoon", to: "home#willbesoon"
  get "feed", to: "home#feed"
  get "user", to: "home#user"
  get "registration", to: "home#registration"
  get "signin", to: "home#signin" # если нужна отдельная страница входа в HTML

  # Обработчики ошибок
  match "/403", to: "errors#forbidden", via: :all
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_error", via: :all
  match "*path", to: "errors#not_found", via: :all

  # Главная страница
  root "home#about"
end
