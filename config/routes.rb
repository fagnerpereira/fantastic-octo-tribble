Rails.application.routes.draw do
  root "pages#home"

  get "chats/show"
  get "pages/home"

  get "sign_up", to: "users#new"
  post "sign_up", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  resources :users, only: [ :show, :edit, :update ]
  resources :jobs, only: [ :index, :new, :create, :show, :edit, :update, :destroy ]
  resources :chats, only: :show do
    resources :messages
  end

  # get "mural", to: "jobs#index"
  get "dashboard", to: "clients#dashboard"

  # Health check
  get "up" => "rails/health#show", :as => :rails_health_check
end
