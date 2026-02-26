require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  authenticate :user, ->(u) { u.admin? } do
    namespace :admin do
      mount Flipper::UI.app => '/flipper'
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  root to: "home#index"

  resources :contact_forms, only: %i[new create]
  resources :broken_link_reports
  resources :songs
  resources :restricted_category_sessions, only: %i[new create], path: "sacred"
  resources :playlists, only: %i[index]

  patch '/theme', to: 'themes#update'

  get "donation_thank_you", to: "thank_you#donation"
  get "purchase_thank_you", to: "thank_you#purchase"
  get "sacred", to: "restricted_category_sessions#new", as: :sacred_password
  get "donations", to: "donations#new"
  get "purchase", to: "downloads#new"
  get "quechua", to: "site#quechua"
  get "ikaros", to: "site#ikaros"
  get "learning_music", to: "site#learning_music"
  get "integration", to: "site#integration"
  get "sacred_info", to: "site#sacred_info"

  get "who_we_are", to: "site#who_we_are"
  get "honoring_the_artists", to: "site#honoring_the_artists"
  get "resources", to: "site#resources"
  get "song_book", to: "site#song_book"
end
