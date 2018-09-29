Rails.application.routes.draw do
  root 'application#home'
  get 'checkin/new', to: 'checkins#new'
  post 'check_in', to: 'checkins#check_in'
  post 'check_qr_code', to: 'checkins#check_qr_code'

  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }

  devise_scope :admin do
    get 'sign_in', to: 'devise/sessions#new', as: :new_admin_session
    delete 'sign_out', to: 'devise/sessions#destroy', as: :destroy_admin_session
  end

  resources :admins

  resources :promotions do
    collection do
      get 'find/:code', to: 'promotions#find'
    end
  end

  resources :teams do
    member do
      get :home_stadium
    end
    get :ticket_types, to: 'ticket_types#season'
  end
  
  resources :stadiums do
    resources :zones
  end
  
  resources :matches do
    resources :ticket_types
  end

  resources :customers
  
  resources :seasons do
    collection do
      get :total_price, to: 'seasons#total_price'
    end
    get :season_time, to: 'seasons#generate_data'
  end

  resources :orders do
    member do
      get :logs
    end

    collection do
      get :new_season_order, as: :new_season
    end
  end

  get 'download/:id', to: 'csv_files#download', as: :csv_download
  get 'qr_download/:id', to: 'qr_codes#download', as: :qr_download
  get 'qr_codes', to: 'qr_codes#index', as: :qr_codes
  get 'qr_generator', to: 'qr_codes#new_qr_generator', as: :qr_generator
  post 'qr_generator', to: 'qr_codes#reference_qr_generator'
  get 'qr_code/:team_id/ticket_types', to: 'qr_codes#team_ticket_types', format: 'json'

  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'
end
