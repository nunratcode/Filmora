Rails.application.routes.draw do
  devise_for :users

  # health check и PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest


  # профили
  resources :profiles, only: [ :index, :show, :new, :create, :edit, :update ] do
    member do
      get :content
    end
  end

  # теги
  resources :tags, only: [ :index, :show ]

  # статьи
  resources :articles do
    collection do
      get :tagged
    end
  end

  # посты
  resources :posts do
    collection do
      get :feed
      get :popular
      get :search
    end

    # комменты
    resources :comments, only: [ :create, :edit, :update, :destroy ], shallow: true

    # лайки и закладки
    resources :likes, only: [ :create ], shallow: true
    resources :favorites, only: [ :create ], shallow: true

    # тонглы для лайков и закладок
    member do
      post :toggle_like
      post :toggle_bookmark
    end
  end

  # удаление лайков и закладок
  resources :likes, only: [ :destroy ]
  resources :favorites, only: [ :destroy ]

  # подписки
  resources :subscriptions, only: [ :create, :destroy ]

  # сообщения
  resources :messages, only: [ :index, :show, :create, :destroy ] do
    collection do
      get :sent
      get :inbox
    end
  end

  # админская часть
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

  get "aboutus", to: "home#aboutus"
  get "willbesoon", to: "home#willbesoon"

  # делаем заглушку главной страницей
  root "home#aboutus"
end
