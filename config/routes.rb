# config/routes.rb
Rails.application.routes.draw do
  resources :projects
  # resources :tasks
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # RESTful project/task/time_entry nesting
  resources :projects do
    resources :tasks do
      resources :time_entries
    end
  end

  resources :tasks do
    collection do
      get "list"
      get :search
    end
  end

  # Global non-nested access to time_entries
  resources :time_entries do  # , only: [ :new, :create ] do
    collection do
      get "list"  # /time_entries/list
      get :search # , to: "time_entries#search" # added for dynamic/async searching in Select2 multiselector
    end
  end

  # stack to define custom endpoint "GET /search"
  resources :users, only: [] do
    collection do
      get :search
    end
  end

  # Optional report route
  get "report", to: "time_entries#report"

  # Set new root path to new time entry as our starting page
  root to: "home#index"
end
