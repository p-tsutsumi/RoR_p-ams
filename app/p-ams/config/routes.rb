Rails.application.routes.draw do
  resources :attendances, only: [:index, :create, :update] do
    collection do
      patch :clock_out
      get :history
    end
  end
  resources :break_times, only: [:create, :update, :destroy]
  resources :idp_users, path: "users"

  get "/login", to: "home#index"
  get "/auth/:provider/callback", to: "sessions#create"
  get "/auth/failure", to: "sessions#failure"
  delete "/logout", to: "sessions#destroy"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
  match "*path", to: redirect("/login"), via: :all
end
