Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  root to: 'songs#index'

  resources :songs
  resources :restricted_category_sessions
end
