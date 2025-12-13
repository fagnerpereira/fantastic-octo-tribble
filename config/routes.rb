Rails.application.routes.draw do
  get "chats/show"
  get "pages/home"
  root "pages#home"

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :jobs, only: [:index, :new, :create, :show]
  resources :chats, only: [:show]
  get "mural", to: "jobs#index"

  get "dashboard", to: "clients#show"

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
