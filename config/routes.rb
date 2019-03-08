Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root to: 'songs#index'

  resources :contact_forms, only: [:new, :create]
  resources :songs
  resources :restricted_category_sessions
end
