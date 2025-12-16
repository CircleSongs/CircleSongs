Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config

  ActiveAdmin.routes(self)

  authenticate :user, ->(u) { u.admin? } do
    namespace :admin do
      mount Flipper::UI.app => '/flipper'
    end
  end

  root to: "songs#index"

  resources :contact_forms, only: %i[new create]
  resources :broken_link_reports
  resources :songs
  resources :restricted_category_sessions

  get "donation_thank_you", to: "thank_you#donation"
  get "purchase_thank_you", to: "thank_you#purchase"
  get "sacred", to: "restricted_category_sessions#new", as: :sacred_password
  get "donations", to: "donations#new"
  get "purchase", to: "downloads#new"
  get "quechua", to: "site#quechua"
  get "icaros", to: "site#icaros"
  get "integration", to: "site#integration"
  get "learning_music", to: "site#learning_music"
end
