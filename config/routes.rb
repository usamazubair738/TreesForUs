Rails.application.routes.draw do
  get "dashboard/index"
  resources :user_profiles
  
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  resources :users
  resources :relationships, only: [:create, :destroy, :new]

  authenticated :user do
    root to: "dashboard#index", as: :authenticated_root
  end

  unauthenticated do
    root to: redirect("/users/sign_in")
  end

  get "up" => "rails/health#show", as: :rails_health_check
end